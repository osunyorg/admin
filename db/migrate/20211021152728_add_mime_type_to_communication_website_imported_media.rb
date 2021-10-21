class AddMimeTypeToCommunicationWebsiteImportedMedia < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_imported_media, :mime_type, :string
  end
end
