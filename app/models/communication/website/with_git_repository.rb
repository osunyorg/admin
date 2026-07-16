module Communication::Website::WithGitRepository
  extend ActiveSupport::Concern

  included do
    has_many  :website_git_files,
              class_name: 'Communication::Website::GitFile',
              dependent: :destroy
              alias_method :git_files, :website_git_files

    has_many  :website_git_file_orphans,
              foreign_key: :communication_website_id,
              class_name: 'Communication::Website::GitFile::Orphan',
              dependent: :destroy
              alias_method :git_file_orphans, :website_git_file_orphans

    has_many  :website_git_file_layouts,
              foreign_key: :communication_website_id,
              class_name: 'Communication::Website::GitFile::Layout',
              dependent: :destroy
              alias_method :git_file_layouts, :website_git_file_layouts

    # Local check to prevent network request to API if repositry format is invalid
    validate :repository_format_is_valid, if: -> { repository.present? }

    validate :access_token_allows_repository_access, if: :should_validate_git_access?

    after_save :mark_obsolete_git_files, if: :should_clean_on_git?

    # Used to automatically mark all git_files as desynchronized if git_provider or repository have changed
    # In that case all content is not in the new repository and should be pushed
    after_save :force_resync_with_git!, if: :should_force_resync_with_git?

    scope :with_repository, -> { where.not(repository: [nil, '']) }
    scope :with_desynchronized_git_files, -> {
      joins(:website_git_files).merge(Communication::Website::GitFile.desynchronized).distinct
    }
  end

  class_methods do
    def git_provider_default_endpoints
      git_providers.keys.index_with do |provider|
        provider_class = "Git::Providers::#{provider.titleize}".constantize
        provider_class::DEFAULT_ENDPOINT if provider_class.const_defined?(:DEFAULT_ENDPOINT, false)
      end
    end

    def git_provider_default_branches
      git_providers.keys.index_with do |provider|
        provider_class = "Git::Providers::#{provider.titleize}".constantize
        provider_class::DEFAULT_BRANCH
      end
    end
  end

  def git_repository
    @git_repository ||= Git::Repository.new self
  end

  def git_provider_default_endpoint
    self.class.git_provider_default_endpoints[git_provider]
  end

  def git_provider_default_branch
    self.class.git_provider_default_branches[git_provider]
  end

  def repository_url
    git_repository.url
  end

  # Override du GeneratesGitFiles
  # Dans le cas du website, on permet de suivre les objets directs car on souhaite tout regénérer
  def identify_git_files_safely
    generate_git_file_for_array(
      recursive_dependencies_following_direct + references
    )
  end

  def sync_with_git
    Communication::Website::SyncWithGitJob.perform_later(id)
  end

  def sync_with_git_safely
    sync_cutoff = Time.zone.now
    desynchronized_git_files = git_files.generated
                                        .desynchronized_until(sync_cutoff)
                                        .order(:desynchronized_at)
                                        .limit(git_repository.batch_size)
    return if desynchronized_git_files.empty?
    return unless git_repository.valid?
    git_repository.git_files = desynchronized_git_files
    begin
      git_repository.sync!
    rescue Git::Providers::Abstract::Error => e
      # We re-check all git access parameters only if a failure occurs
      # This triggers the notification email if needed
      git_repository.check_repository_access!
      # If all params are OK, it is a temporary network error
      raise e
    end
    # We updates last_sync_at when sync is really done/successful
    update_column(:last_sync_at, sync_cutoff)
    if git_files.desynchronized_until(sync_cutoff).any?
      # More than one batch, we need to requeue the job
      Communication::Website::SyncWithGitJob.perform_later(id)
    end
  end

  # If git_provider or repository fields have changed, mark all git_files as desynchronized
  # User must still trigger the sync manually using the Synchronize button
  def force_resync_with_git!
    git_files.generated.update_all(desynchronized: true, desynchronized_at: Time.zone.now)
  end

  def should_force_resync_with_git?
    return false unless repository.present?
    git_access_field_saved_change?(:repository) || git_access_field_saved_change?(:git_provider)
  end

  # Check if specific fields have been modified after save of website record
  def git_access_field_saved_change?(attribute)
    return false unless public_send("saved_change_to_#{attribute}?")
    before, after = public_send("saved_change_to_#{attribute}")
    before.presence != after.presence
  end

  def generate_git_file_for_array(array)
    array.each do |object|
      generate_git_file_for_object(object)
    end
  end

  def generate_git_file_for_object(object)
    Communication::Website::GitFile.generate self, object
  end

  # Marque comme obsolete tous les git_files qui ne sont pas dans les recursive_dependencies_following_direct
  def mark_obsolete_git_files
    return unless git_repository.valid?
    git_files.find_each do |git_file|
      begin
        dependency = git_file.about
      rescue NameError
        depdendency = nil
      end
      # Here, dependency can be nil (object was previously destroyed)
      is_obsolete = dependency.nil? || !dependency.in?(recursive_dependencies_following_direct)
      git_file.mark_for_destruction! if is_obsolete
    end
  end

  def should_validate_git_access?
    return false if access_token.blank?
      git_access_field_changed?(:access_token) ||
      git_access_field_changed?(:git_provider) ||
      git_access_field_changed?(:git_endpoint) ||
      git_access_field_changed?(:repository) ||
      git_access_field_changed?(:git_branch)
  end

  def git_access_field_changed?(attribute)
    return false unless public_send("will_save_change_to_#{attribute}?")
    before, after = public_send("#{attribute}_change")
    before.presence != after.presence
  end


  def repository_format_is_valid
    git_repository.check_repository_format!
  rescue Git::Providers::Abstract::InvalidRepositoryIdentifier
    errors.add(:repository, :invalid)
  end

  def access_token_allows_repository_access
    git_repository.check_repository_access!
  rescue StandardError => e
    add_git_access_error(e)
  end

  # Triggered via url parameter ?check_git_access=true
  def check_git_access
    if access_token.blank?
      errors.add(:access_token, :blank)
      return false
    end
    git_repository.check_repository_access!
    true
  rescue StandardError => e
    add_git_access_error(e)
    false
  end

  GIT_ACCESS_FIELDS = %i[git_provider git_endpoint access_token repository git_branch].freeze

  # Used to hide the "Test connection" button in case of error
  # to force the user to use the Save button instead
  def git_access_errors?
    GIT_ACCESS_FIELDS.any? { |field| errors[field].present? }
  end

  # Mapping between each error/exception class and the corresponding field and message
  def add_git_access_error(exception)
    case exception
    when Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, SocketError, Timeout::Error, EOFError,
      Git::Providers::Abstract::EndpointUnreachable
      errors.add(:git_endpoint, :unreachable)
    when Git::Providers::Abstract::InvalidEndpoint
      errors.add(:git_endpoint, :invalid)
    when Git::Providers::Abstract::Unauthorized
      errors.add(:access_token, :unauthorized)
    when Git::Providers::Abstract::RepositoryForbidden
      errors.add(:access_token, :forbidden)
    when Git::Providers::Abstract::RepositoryNotFound
      errors.add(:repository, :not_found)
    when Git::Providers::Abstract::InvalidRepositoryIdentifier, Octokit::InvalidRepository
      errors.add(:repository, :invalid)
    when Git::Providers::Abstract::BranchNotFound
      errors.add(:git_branch, :not_found)
    when Git::Providers::Abstract::BranchProtected
      errors.add(:git_branch, :protected)
    when Git::Providers::Abstract::WorkflowsForbidden
      errors.add(:access_token, :workflows_forbidden)
    else
      raise exception
    end
  end

  GIT_ACCESS_ERROR_I18N_SCOPE = 'mailers.notifications.website_git_access_broken.errors'

  # Translation strings to be used in the notification email website_git_access_broken
  def git_access_error_message(exception)
    case exception
    when Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, SocketError, Timeout::Error, EOFError,
      Git::Providers::Abstract::EndpointUnreachable
      I18n.t("#{GIT_ACCESS_ERROR_I18N_SCOPE}.unreachable", endpoint: git_endpoint.presence || git_provider_default_endpoint)
    when Git::Providers::Abstract::InvalidEndpoint
      I18n.t("#{GIT_ACCESS_ERROR_I18N_SCOPE}.invalid_endpoint")
    when Git::Providers::Abstract::Unauthorized
      I18n.t("#{GIT_ACCESS_ERROR_I18N_SCOPE}.unauthorized")
    when Git::Providers::Abstract::RepositoryForbidden
      I18n.t("#{GIT_ACCESS_ERROR_I18N_SCOPE}.repository_forbidden", repository: repository)
    when Git::Providers::Abstract::RepositoryNotFound
      I18n.t("#{GIT_ACCESS_ERROR_I18N_SCOPE}.repository_not_found", repository: repository)
    when Git::Providers::Abstract::InvalidRepositoryIdentifier, Octokit::InvalidRepository
      I18n.t("#{GIT_ACCESS_ERROR_I18N_SCOPE}.invalid_repository", repository: repository)
    when Git::Providers::Abstract::BranchNotFound
      I18n.t("#{GIT_ACCESS_ERROR_I18N_SCOPE}.branch_not_found", branch: git_branch.presence || git_provider_default_branch)
    when Git::Providers::Abstract::BranchProtected
      I18n.t("#{GIT_ACCESS_ERROR_I18N_SCOPE}.branch_protected", branch: git_branch.presence || git_provider_default_branch)
    when Git::Providers::Abstract::WorkflowsForbidden
      I18n.t("#{GIT_ACCESS_ERROR_I18N_SCOPE}.workflows_forbidden")
    else
      exception.message
    end
  end

  # Shared between notify_invalid_access_token! and notify_git_access_broken!
  def git_access_users_to_notify
    university.users.where(role: [:server_admin, :admin]) + university.users.website_manager.where(id: manager_ids)
  end

  def invalidate_access_token!
    # Nullify the expired token
    update_column :access_token, nil
  end

  # Notify admins that the token was nullified; kept separate from
  # invalidate_access_token! because it should only fire from a job context
  def notify_invalid_access_token!
    git_access_users_to_notify.each do |user|
      NotificationMailer.website_invalid_access_token(self, user).deliver_later
    end
  end

  # Send notification to admins when token is still valid but sync is not possible anymore
  # (wrong perms, repo deleted/moved, branch became protected, etc.)
  def notify_git_access_broken!(error)
    git_access_users_to_notify.each do |user|
      error_message = I18n.with_locale(user.language.iso_code) { git_access_error_message(error) }
      NotificationMailer.website_git_access_broken(self, user, error_message).deliver_later
    end
  end

  def should_clean_on_git?
    # Clean website if about was present and changed
    saved_change_to_about_id? && about_id_before_last_save.present?
  end

  def update_theme_version
    Communication::Website::UpdateThemeVersionJob.perform_later(id)
  end

  def update_theme_version_safely
    return unless git_repository.valid?
    begin
      git_repository.update_theme_version!
    rescue Git::Providers::Abstract::Error => e
      # We re-check all git access parameters only if a failure occurs
      git_repository.check_repository_access!
      # If all params are OK, it is a temporary network error
      raise e
    end
  end

  def analyse_repository_safely
    return unless git_repository.valid?
    git_repository.check_repository_access!
    Git::OrphanAndLayoutAnalyzer.new(self).launch
  end

  def analyse_repository
    return unless git_repository.valid?
    Communication::Website::AnalyseJob.perform_later(id)
  end

  def desynchronized_generated_git_files
    git_files_list = git_files.generated
    last_sync_at.nil? ? git_files_list.desynchronized
                      : git_files_list.desynchronized_since(last_sync_at)
  end

  # Checks if a sync is already scheduled for this website
  # (We hide the Synchronize button in that case to prevent duplicates jobs enqueing)
  def sync_with_git_scheduled?
    GoodJob::Job.job_class('Communication::Website::SyncWithGitJob')
                .unfinished
                .where("serialized_params -> 'arguments' ->> 0 = ?", id)
                .exists?
  end
end
