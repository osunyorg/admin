class ReplaceDatetimesInCommunicationWebsiteImportedMedia < ActiveRecord::Migration[6.1]
  def change
    remove_column :communication_website_imported_media, :created_at, :datetime
    remove_column :communication_website_imported_media, :updated_at, :datetime
    rename_column :communication_website_imported_media, :remote_created_at, :created_at
    rename_column :communication_website_imported_media, :remote_updated_at, :updated_at
  end
end
