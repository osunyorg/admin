class Communication::Website::DirectObject::SyncWithGitJob < ApplicationJob
  def perform(direct_object)
    direct_object.sync_with_git_safely
  end
end