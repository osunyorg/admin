class Communication::CleanWebsitesJob < ApplicationJob
  queue_as :default

  def perform(websites_ids)
    websites = Communication::Website.where(id: websites_ids)
    websites.each do |website|
      website.destroy_obsolete_connections
      website.destroy_obsolete_git_files
    end
  end
end