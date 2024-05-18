class Communication::Website::DestroyObsoleteGitFilesJob < Communication::Website::BaseJob
  def execute
    website.destroy_obsolete_git_files_safely
  end
end