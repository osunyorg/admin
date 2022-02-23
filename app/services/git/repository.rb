class Git::Repository
  attr_reader :website, :commit_message

  def initialize(website)
    @website = website
  end

  def add_git_file(git_file)
    if git_files.empty?
      action = git_file.should_destroy? ? "Destroy" : "Save"
      @commit_message = "[#{ git_file.about.class.name }] #{ action } #{ git_file.about }"
    end
    git_files << git_file
  end

  def sync!
    return if git_files.empty?
    sync_git_files
    mark_as_synced if provider.push(commit_message)
  end

  def computed_sha(string)
    provider.computed_sha(string)
  end

  def git_sha(path)
    provider.git_sha path
  end

  def valid?
    provider.valid?
  end

  protected

  def provider
    @provider ||= provider_class.new(website&.access_token, website&.repository)
  end

  def provider_class
    @provider_class ||= "Git::Providers::#{website.git_provider.titleize}".constantize
  end

  def git_files
    @git_files ||= []
  end

  def sync_git_files
    git_files.each do |file|
      if file.should_create?
        provider.create_file file.path, file.to_s
      elsif file.should_update?
        provider.update_file file.path, file.previous_path, file.to_s
      elsif file.should_destroy?
        provider.destroy_file file.previous_path
      end
    end
  end

  def mark_as_synced
    git_files.each do |git_file|
      path = git_file.path
      sha = provider.git_sha path
      git_file.update previous_path: path,
                      previous_sha: sha
    end
  end
end
