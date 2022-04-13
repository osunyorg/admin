class RemoveAboutFromCommunicationWebsitePages < ActiveRecord::Migration[6.1]
  def change
    remove_column :communication_website_pages, :about_type
    remove_column :communication_website_pages, :about_id
  end
end
