class Communication::Website::DirectObject::SyncWithGitJob < ApplicationJob
  queue_as :elephant

  def perform(direct_object)
    direct_object.sync_with_git_safely
  end
end