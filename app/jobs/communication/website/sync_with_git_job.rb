class Communication::Website::SyncWithGitJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.sync_with_git_safely
  end
end