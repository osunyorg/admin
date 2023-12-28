class AddPublishedAtToCommunicationWebsitePage < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_website_pages, :published_at, :datetime
    Communication::Website::Page.where(published: true).update_all("published_at = updated_at")
  end
end
