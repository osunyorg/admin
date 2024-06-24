module Git::Providers::Github::WithTheme
  extend ActiveSupport::Concern

  def update_theme
    previous_theme_sha = git_sha(ENV["GITHUB_WEBSITE_THEME_PATH"])
    batch << {
      path: ENV["GITHUB_WEBSITE_THEME_PATH"],
      mode: '160000',
      type: 'commit',
      sha: current_theme_sha
    } if previous_theme_sha != current_theme_sha
  end

  protected

  def current_theme_sha
    @current_theme_sha ||= Osuny::ThemeInfo.get_current_sha
  end

end