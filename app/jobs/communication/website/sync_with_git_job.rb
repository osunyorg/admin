class Communication::Website::SyncWithGitJob < Communication::Website::BaseJob
  def execute
    return unless website.should_sync_with_git?
    website.sync_with_git_safely
  end
end