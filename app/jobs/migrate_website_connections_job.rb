class MigrateWebsiteConnectionsJob < ApplicationJob
  queue_as :default

  def perform(website_id)
    website = Communication::Website.find(website_id)
    website.pages.find_each(&:connect_dependencies)
    website.posts.find_each(&:connect_dependencies)
    website.categories.find_each(&:connect_dependencies)
    website.menus.find_each(&:connect_dependencies)
    website.connect(website.about, website) if website.about.present?

    website.destroy_obsolete_connections
    website.sync_with_git
    website.destroy_obsolete_git_files
  end
end
