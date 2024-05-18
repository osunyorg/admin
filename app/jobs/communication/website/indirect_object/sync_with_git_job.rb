class Communication::Website::IndirectObject::SyncWithGitJob < ApplicationJob
  def perform(website, indirect_object)
    website.sync_with_git_safely(indirect_object)
  end
end