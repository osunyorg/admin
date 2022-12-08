class RenameCommunicationWebsitePermalinks < ActiveRecord::Migration[7.0]
  def change
    rename_table :communication_website_previous_links, :communication_website_permalinks
  end
end
