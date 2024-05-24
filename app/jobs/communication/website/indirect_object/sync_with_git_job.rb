class Communication::Website::IndirectObject::SyncWithGitJob < ApplicationJob
  queue_as :mice

  def perform(website, indirect_object)
    website.sync_indirect_object_with_git(indirect_object)
  end
end