class RemoveCommunicationWebsiteMedia < ActiveRecord::Migration[6.1]
  def change
    remove_column :communication_website_imported_media, :medium_id
    drop_table :communication_website_media
  end
end
