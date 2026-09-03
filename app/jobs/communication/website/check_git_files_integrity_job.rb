class Communication::Website::CheckGitFilesIntegrityJob < Communication::Website::BaseJob
  queue_as :elephants

  def execute
    website.check_git_files_integrity_safely
  end

end
