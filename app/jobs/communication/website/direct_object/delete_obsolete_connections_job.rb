
class Communication::Website::DirectObject::DeleteObsoleteConnectionsJob < Communication::Website::BaseJob

  def execute
    direct_object = options.fetch(:direct_object)
    direct_object.delete_obsolete_connections_safely if direct_object.present?
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