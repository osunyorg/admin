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

    after_save :destroy_obsolete_git_files, if: :should_clean_on_git?

    scope :with_repository, -> { where.not(repository: [nil, '']) }

  end

  def git_repository
    @git_repository ||= Git::Repository.new self
  end

  def repository_url
    git_repository.url
  end

  # Synchronisation optimale d'objet indirect
  def sync_indirect_object_with_git(indirect_object)
    indirect_object.direct_sources_with_dependencies_for_website(self).each do |dependency|
      Communication::Website::GitFile.sync self, dependency
    end
    git_repository.sync!
  end

  # Supprimer tous les git_files qui ne sont pas dans les recursive_dependencies_syncable
  def destroy_obsolete_git_files
    Communication::Website::DestroyObsoleteGitFilesJob.perform_later(id)
  end

  def destroy_obsolete_git_files_safely
    return unless should_sync_with_git?
    website_git_files.find_each do |git_file|
      dependency = git_file.about
      # Here, dependency can be nil (object was previously destroyed)
      is_obsolete = dependency.nil? || !dependency.in?(recursive_dependencies_syncable_following_direct)
      if is_obsolete
        Communication::Website::GitFile.mark_for_destruction(self, git_file)
      end
    end
    git_repository.sync!
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

  # Le website devient data/website.yml
  # Les configs héritent du modèle website et s'exportent en différents fichiers
  def exportable_to_git?
    true
  end

  def should_clean_on_git?
    # Clean website if about was present and changed
    saved_change_to_about_id? && about_id_before_last_save.present?
  end

  def update_theme_version
    Communication::Website::UpdateThemeVersionJob.perform_later(id)
  end

  def update_theme_version_safely
    return unless should_sync_with_git?
    git_repository.update_theme_version!
  end

end
