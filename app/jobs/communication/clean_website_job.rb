class Communication::CleanWebsiteJob < ApplicationJob
  queue_as :long_cleanup

  def perform(website_id)
    website = Communication::Website.find_by(id: website_id)
    return unless website.present?
    website.destroy_obsolete_connections
    website.destroy_obsolete_git_files
  end
end