class Git::Repository
  attr_reader :website, :commit_message

  def initialize(website)
    @website = website
  end

  def add_git_file(git_file)
    @commit_message = "[#{ git_file.about.class.name }] Save #{ git_file.about }" if git_files.empty?
    git_files << git_file
  end

  def sync!
    return if git_files.empty?
    sync_git_files
    mark_as_synced if provider.push(commit_message)
  end

  protected

  def provider
    @provider ||= Git::Providers::Github.new(website&.access_token, website&.repository)
  end

  def git_files
    @git_files ||= []
  end

  def sync_git_files
    git_files.each do |git_file|
      next if git_file.synced?
      provider.add_to_batch path: git_file.path,
                            previous_path: git_file.previous_path,
                            data: git_file.to_s
    end
  end

  def mark_as_synced
    git_files.each do |git_file|
      git_file.update_columns previous_path: git_file.path, previous_sha: git_file.sha
    end
  end
end
