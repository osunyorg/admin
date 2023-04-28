module Communication::Website::WithGitRepository
  extend ActiveSupport::Concern

  included do
    has_many :website_git_files,
             class_name: 'Communication::Website::GitFile',
             dependent: :destroy
  end

  def git_repository
    @git_repository ||= Git::Repository.new self
  end

  # Supprimer tous les git_files qui ne sont pas dans les recursive_dependencie_syncable
  def destroy_obsolete_git_files
    website_git_files.find_each do |git_file|
      dependency = git_file.about
      is_obsolete = !dependency.in?(recursive_dependencie_syncable)
      if is_obsolete
        # TODO git_file.destroy serait plus ActiveRecord
        Communication::Website::GitFile.sync(self, dependency, destroy: true)
      end
    end
    self.git_repository.sync!
  end
  handle_asynchronously :destroy_obsolete_git_files, queue: :default
end
