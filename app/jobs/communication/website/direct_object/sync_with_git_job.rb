class Communication::Website::DirectObject::SyncWithGitJob < ApplicationJob
  queue_as :elephant

  def perform(direct_object)
    direct_object.sync_with_git_safely
  rescue ActiveJob::DeserializationError
    # Website or direct_object does not exist anymore
  end
end