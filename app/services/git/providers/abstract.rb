class Git::Providers::Abstract
  attr_reader :git_repository, :endpoint, :branch, :access_token, :repository

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
    raise NoMethodError, "You must implement the `url` method in #{self.class.name}"
  end

  def create_file(path, content)
    raise NoMethodError, "You must implement the `create_file` method in #{self.class.name}"
  end

  def update_file(path, previous_path, content)
    raise NoMethodError, "You must implement the `update_file` method in #{self.class.name}"
  end

  def destroy_file(path)
    raise NoMethodError, "You must implement the `destroy_file` method in #{self.class.name}"
  end

  def update_theme
    raise NoMethodError, "You must implement the `update_theme` method in #{self.class.name}"
  end

  def push(commit_message)
    raise NoMethodError, "You must implement the `push` method in #{self.class.name}"
  end

  def previous_sha(git_file)
    git_sha(git_file.previous_path)
  end

  def computed_sha(string)
    raise NoMethodError, "You must implement the `computed_sha` method in #{self.class.name}"
  end

  def git_sha(path)
    raise NoMethodError, "You must implement the `git_sha` method in #{self.class.name}"
  end

  def files_in_the_repository
    []
  end

  protected

  def batch
    @batch ||= []
  end

  def current_theme_sha
    @current_theme_sha ||= Osuny::ThemeInfo.get_current_sha
  end

  def previous_theme_sha
    @previous_theme_sha ||= git_sha(ENV["GITHUB_WEBSITE_THEME_PATH"])
  end

  def should_update_theme?
    previous_theme_sha != current_theme_sha
  end

  def update_theme_message
    theme_name = ENV["GITHUB_WEBSITE_THEME_REPOSITORY"].to_s.split("/").last
    "Updated #{theme_name} version"
  end
end
