class Git::Repository
  attr_accessor :git_files
  attr_reader :website

  def initialize(website)
    @website = website
    @git_files = []
  end

  def url
    provider.url
  end

  def batch_size
    provider.class::COMMIT_BATCH_SIZE
  end

  def sync!
    return if git_files.empty?
    puts "Start sync"
    synchronize_git_files
    refresh_git_files if provider.push('Sync from Osuny')
  end

  def update_theme_version!
    provider.update_theme
    theme_name = ENV["GITHUB_WEBSITE_THEME_REPOSITORY"].to_s.split("/").last
    provider.push("Updated #{theme_name} version")
  end

  # Based on content, with the provider's algorithm (sha1 or sha256)
  def computed_sha(string)
    provider.computed_sha(string)
  end

  def previous_sha(git_file)
    provider.previous_sha(git_file)
  end

  def git_sha(path)
    provider.git_sha path
  end

  def valid?
    provider.valid?
  end

  def init_from_template(name)
    provider.init_from_template(name)
  end

  def update_secrets(secrets)
    provider.update_secrets(secrets)
  end

  def files_in_the_repository
    provider.files_in_the_repository
  end

  protected

  def provider
    @provider ||= provider_class.new self
  end

  def provider_class
    @provider_class ||= "Git::Providers::#{website.git_provider.titleize}".constantize
  end

  def analyzer
    @analyzer ||= Git::Analyzer.new self
  end

  def synchronize_git_files
    git_files.each do |git_file|
      analyzer.git_file = git_file
      if analyzer.should_create?
        puts "Syncing - Creating #{git_file.current_path}"
        provider.create_file git_file.current_path,
                             git_file.current_content
      elsif analyzer.should_update?
        puts "Syncing - Updating #{git_file.current_path}"
        provider.update_file git_file.current_path,
                             git_file.previous_path,
                             git_file.current_content
      elsif analyzer.should_destroy?
        puts "Syncing - Destroying #{git_file.previous_path}"
        provider.destroy_file git_file.previous_path
      else
        puts "Syncing - Nothing to do with #{git_file.current_path}"
      end
    end
  end

  def refresh_git_files
    puts "Refreshing git files"
    git_files.each do |git_file|
      analyzer.git_file = git_file
      if analyzer.should_destroy?
        puts "Destroying #{git_file.previous_path}"
        git_file.destroy
      else
        puts "Marking #{git_file.current_path}"
        git_file.mark_as_synced!
      end
    end
  end
end
