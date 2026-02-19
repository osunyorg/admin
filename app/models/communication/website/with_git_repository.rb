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

    after_save :mark_obsolete_git_files, if: :should_clean_on_git?

    scope :with_repository, -> { where.not(repository: [nil, '']) }
    scope :with_desynchronized_git_files, -> {
      joins(:website_git_files).merge(Communication::Website::GitFile.desynchronized).distinct
    }
  end

  def git_repository
    @git_repository ||= Git::Repository.new self
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
    update_column(:last_sync_at, Time.now)
    Communication::Website::SyncWithGitJob.perform_later(id)
  end

  def sync_with_git_safely
    return unless git_repository.valid?
    git_repository.git_files = git_files.desynchronized_until(last_sync_at)
                                        .order(:desynchronized_at)
                                        .limit(git_repository.batch_size)
    git_repository.sync!
    if git_files.desynchronized_until(last_sync_at).any?
      # More than one batch, we need to requeue the job
      Communication::Website::SyncWithGitJob.perform_later(id)
    end
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
      dependency = git_file.about
      # Here, dependency can be nil (object was previously destroyed)
      is_obsolete = dependency.nil? || !dependency.in?(recursive_dependencies_following_direct)
      git_file.mark_for_destruction! if is_obsolete
    end
  end

  def invalidate_access_token!
    # Nullify the expired token
    update_column :access_token, nil
    # Notify admins and website managers managing this website.
    users_to_notify = university.users.admin + university.users.website_manager.where(id: manager_ids)
    users_to_notify.each do |user|
      NotificationMailer.website_invalid_access_token(self, user).deliver_later
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
    git_repository.update_theme_version!
  end

  def analyse_repository_safely
    return unless git_repository.valid?
    Git::OrphanAndLayoutAnalyzer.new(self).launch
  end

  def analyse_repository
    return unless git_repository.valid?
    Communication::Website::AnalyseJob.perform_later(id)
  end

  def git_files_desynchronized
    last_sync_at.nil? ? git_files.desynchronized : git_files.desynchronized_since(last_sync_at)
  end
end
