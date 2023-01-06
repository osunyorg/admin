class AddAboutIndexInCommunicationWebsitePermalinks < ActiveRecord::Migration[7.0]
  def change
    add_index :communication_website_permalinks, [:about_type, :about_id], name: :index_communication_website_permalinks_on_about
  end
end
