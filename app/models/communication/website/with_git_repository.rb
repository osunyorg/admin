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

  def sync_objects_with_git(objects)
    touch
    return unless git_repository.valid?
    objects.each do |object|
      next unless object.has_website_for_self?(self)
      dependencies = object.git_dependencies(self).to_a.flatten.uniq.compact
      dependencies.each do |dependency|
        Communication::Website::GitFile.sync self, dependency
      end
    end
    git_repository.sync!
  end
  handle_asynchronously :sync_objects_with_git, queue: 'default'
end
