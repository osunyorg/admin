class Communication::Website::SyncWithGitJob < Communication::Website::BaseJob
  def execute
    website.sync_with_git_safely
  end
end