class Git::Providers::Abstract
  attr_reader :endpoint, :access_token, :repository

  def initialize(endpoint, access_token, repository)
    @endpoint = endpoint
    @access_token = access_token
    @repository = repository
  end

  def valid?
    repository.present? && access_token.present?
  end

  protected

  def batch
    @batch ||= []
  end
end
