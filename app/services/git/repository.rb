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

  def git_sha(path)
    provider.git_sha path
  end

  protected

  # TODO add gitlab
  def provider
    @provider ||= Git::Providers::Github.new(website&.access_token, website&.repository)
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
      git_file.update_columns previous_path: git_file.path, previous_sha: git_file.sha
    end
  end
end
