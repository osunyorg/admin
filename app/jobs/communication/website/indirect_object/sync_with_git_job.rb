class Communication::Website::IndirectObject::SyncWithGitJob < Communication::Website::BaseJob
  def execute
    indirect_object = options.fetch(:indirect_object)
    website.sync_indirect_object_with_git(indirect_object) if indirect_object.present?
  end

  protected

  def good_job_additional_labels
    website = Communication::Website.find(arguments.first)
    university = website.university
    [
      university&.to_global_id.to_s,
      website&.to_global_id.to_s
    ]
  end
end