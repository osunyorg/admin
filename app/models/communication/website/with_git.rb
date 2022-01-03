module Communication::Website::WithGit
  extend ActiveSupport::Concern

  included do
    after_commit :push_to_git
  end

  def sync_file(github_file)
    if github_file.needs_sync?
      repository.add_to_batch github_file
      touch!
    end
  end

  def push_to_git
    repository.sync! if repository.needs_sync?
  end
  handle_asynchronously :push_to_git

  protected

  def repository
    @repository ||= Git::Repository.new self
  end
end
