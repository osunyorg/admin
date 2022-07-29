class Git::Repository
  attr_reader :website, :commit_message

  def initialize(website)
    @website = website
  end

  def add_git_file(git_file)
    puts "Adding #{git_file.path}"
    if git_files.empty?
      action = should_destroy_file?(git_file) ? "Destroy" : "Save"
      @commit_message = "[#{ git_file.about.class.name }] #{ action } #{ git_file.about }"
    end
    git_files << git_file
  end

  def sync!
    return if git_files.empty?
    puts "Start sync"
    sync_git_files
    mark_as_synced if provider.push(commit_message)
  end

  # Based on content, with the provider's algorithm (sha1 or sha256)
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
    @provider ||= provider_class.new  website&.git_endpoint,
                                      website&.access_token,
                                      website&.repository
  end

  def provider_class
    @provider_class ||= "Git::Providers::#{website.git_provider.titleize}".constantize
  end

  def git_files
    @git_files ||= []
  end

  def sync_git_files
    git_files.each do |file|
      if should_create_file?(file)
        puts "Syncing - Creating #{file.path}"
        provider.create_file file.path, file.to_s
      elsif should_update_file?(file)
        puts "Syncing - Updating #{file.path}"
        provider.update_file file.path, file.previous_path, file.to_s
      elsif should_destroy_file?(file)
        puts "Syncing - Destroying #{file.previous_path}"
        provider.destroy_file file.previous_path
      else
        puts "Syncing - Nothing to do with #{file.path}"
      end
    end
  end

  # TODO Arnaud : Nettoyer / Rendre + élégant

  def should_create_file?(file)
    !should_destroy_file?(file) &&
    !file_exists_on_git?(file) &&
    (
      !file_synchronized_with_git?(file) ||
      file.previous_path.nil? ||
      file.previous_sha.nil?
    )
  end

  def should_update_file?(file)
    !should_destroy_file?(file) &&
    (
      file.previous_path != file.path ||
      file.previous_sha != computed_sha(file.to_s)
    )
  end

  def should_destroy_file?(file)
    file.will_be_destroyed ||
    file.path.nil?
  end

  def file_exists_on_git?(file)
    git_sha(file.previous_path).present? || # The file exists where it was last time
    (
      file.previous_path.nil? &&  # Never saved in the database
      git_sha(file.path).present? # but it exists in the git repo
    )
  end

  def file_synchronized_with_git?(file)
    file_exists_on_git?(file) && # File exists
    file.previous_path == file.path && # at the same place
    git_sha(file.path) == file.previous_sha # with the same content
  end

  def mark_as_synced
    puts "Marking as synced"
    git_files.each do |git_file|
      if should_destroy_file?(git_file)
        path = nil
        sha = nil
      else
        path = git_file.path
        # TODO Arnaud : Invalider le cache des tree et tree_items_by_path pour GitHub pour faire un appel API au lieu de N calculs de SHA
        sha = computed_sha(git_file.to_s)
      end
      puts "Marking #{path}"
      git_file.update previous_path: path,
                      previous_sha: sha
    end
  end
end
