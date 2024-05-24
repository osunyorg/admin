class Communication::Website::DestroyObsoleteGitFilesJob < Communication::Website::BaseJob
  queue_as :low_priority

  def execute
    website.destroy_obsolete_git_files_safely
  end
end