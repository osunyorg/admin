class AddFilenameToCommunicationWebsiteImportedMedia < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_imported_media, :filename, :string
  end
end
