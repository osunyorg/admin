class Communication::Website::DirectObject::SyncWithGitJob < Communication::Website::BaseJob
  def perform(direct_object)
    direct_object.sync_with_git_safely
  end
end