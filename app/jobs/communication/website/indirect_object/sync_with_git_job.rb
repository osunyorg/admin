class Communication::Website::IndirectObject::SyncWithGitJob < ApplicationJob
  queue_as :elephant

  def perform(website, indirect_object)
    website.sync_indirect_object_with_git(indirect_object)
  rescue ActiveJob::DeserializationError
    # Website or indirect_object does not exist anymore
  end
end