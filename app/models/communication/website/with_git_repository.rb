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

  def destroy_recursive_dependencies_unsyncable
    return if recursive_dependencies_unsyncable.none?
    recursive_dependencies_unsyncable.each do |dependency|
      Communication::Website::GitFile.sync self, dependency, destroy: true
    end
    self.git_repository.sync!
  end
  handle_asynchronously :destroy_recursive_dependencies_unsyncable, queue: :default

end
