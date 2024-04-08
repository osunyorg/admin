class Osuny::ThemeInfo

  def self.get_current_version
    client.releases(ENV["GITHUB_WEBSITE_THEME_REPOSITORY"]).first[:tag_name]
  end

  def self.get_current_sha
    client.branch(ENV["GITHUB_WEBSITE_THEME_REPOSITORY"], ENV["GITHUB_WEBSITE_THEME_BRANCH"])[:commit][:sha]
  end

  private

  def self.client
    @client ||= Octokit::Client.new access_token: ENV["GITHUB_ACCESS_TOKEN"]
  end

end
