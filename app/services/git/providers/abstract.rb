class Git::Providers::Abstract
  attr_reader :endpoint, :branch, :access_token, :repository

  def initialize(endpoint, branch, access_token, repository)
    @endpoint = endpoint
    @branch = branch
    @access_token = access_token
    @repository = repository
  end

  def valid?
    repository.present? && access_token.present?
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
