class Git::Providers::Abstract
  attr_reader :git_repository; :endpoint, :branch, :access_token, :repository

  def initialize(git_repository)
    @git_repository = git_repository
    @endpoint = git_repository.website.git_endpoint
    @branch = git_repository.website.git_branch
    @access_token = git_repository.website.access_token
    @repository = git_repository.website.repository
  end

  def valid?
    repository.present? && access_token.present?
  end

  def url
    raise NotImplementedError
  end

  def create_file(path, content)
    raise NotImplementedError
  end

  def update_file(path, previous_path, content)
    raise NotImplementedError
  end

  def destroy_file(path)
    raise NotImplementedError
  end

  def update_theme
    raise NotImplementedError
  end

  def push(commit_message)
    raise NotImplementedError
  end

  def computed_sha(string)
    raise NotImplementedError
  end

  def git_sha(path)
    raise NotImplementedError
  end

  protected

  def batch
    @batch ||= []
  end
end
