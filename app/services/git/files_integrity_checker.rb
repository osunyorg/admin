class Git::FilesIntegrityChecker
  attr_reader :website, :dry_run, :git_files_to_desynchronize

  def initialize(website, dry_run: false)
    @website = website
    @dry_run = dry_run
    @git_files_to_desynchronize = []
  end

  def launch
    return unless repository.valid? && repository.can_check_git_files_integrity?
    website.git_files.synchronized.find_each do |git_file|
      check_integrity!(git_file)
    end
    puts "Found #{git_files_to_desynchronize.size} git files to desynchronize."
    website.sync_with_git if should_sync_website?
  end

  protected

  def check_integrity!(git_file)
    if missing_git_file?(git_file)
      puts "Missing GitFile #{git_file.id}"
      puts "- path: #{git_file.current_path}"
      desynchronize!(git_file)
    elsif outdated_git_file?(git_file)
      puts "Outdated GitFile #{git_file.id}"
      puts "- path: #{git_file.current_path}"
      puts "- current sha: #{git_file.current_sha}"
      puts "- remote sha: #{repository.git_sha(git_file.current_path)}"
      desynchronize!(git_file)
    end
  end

  def desynchronize!(git_file)
    @git_files_to_desynchronize << git_file
    git_file.update(
      # Note the Git File as desynchronized...
      desynchronized: true,
      desynchronized_at: Time.current,
      # ...and nullify previous SHA to force Git to send the file
      previous_sha: nil
    ) unless dry_run
  end

  def missing_git_file?(git_file)
    !files_in_the_repository.include?(git_file.current_path)
  end

  def outdated_git_file?(git_file)
    git_file.current_sha != repository.git_sha(git_file.current_path)
  end

  def should_sync_website?
    git_files_to_desynchronize.any? && !dry_run
  end

  def repository
    @repository ||= website.git_repository
  end

  def files_in_the_repository
    @files_in_the_repository ||= repository.files_in_the_repository
  end

end
