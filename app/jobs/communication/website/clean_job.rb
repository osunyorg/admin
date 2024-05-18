class Communication::Website::CleanJob < ApplicationJob
  self.good_job_labels = ['website']

  queue_as :long_cleanup

  def perform(website_id)
    website = Communication::Website.find_by(id: website_id)
    return unless website.present?
    website.delete_obsolete_connections_for_self_and_direct_sources
    website.destroy_obsolete_git_files
  end
end