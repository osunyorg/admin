class Communication::Website::DestroyObsoleteGitFilesJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.destroy_obsolete_git_files_safely
  end
end