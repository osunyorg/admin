module University::WithGithub
  extend ActiveSupport::Concern

  def github_access_token
    default_github_access_token.presence || ENV['GITHUB_ACCESS_TOKEN']
  end
end
