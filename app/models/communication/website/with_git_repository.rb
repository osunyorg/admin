module Communication::Website::WithGitRepository
  extend ActiveSupport::Concern

  def git_repository
    @git_repository ||= Git::Repository.new self
  end
end
