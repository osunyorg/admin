class Git::Providers::Abstract
  attr_reader :access_token, :repository

  def initialize(access_token, repository)
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
