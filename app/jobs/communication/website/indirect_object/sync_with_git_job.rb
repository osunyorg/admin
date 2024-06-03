class Communication::Website::IndirectObject::SyncWithGitJob < Communication::Website::BaseJob
  def execute
    indirect_object = options.fetch(:indirect_object)
    website.sync_indirect_object_with_git(indirect_object) if indirect_object.present?
  end
end