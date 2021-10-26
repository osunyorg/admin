class AddVariantUrlsToCommunicationWebsiteImportedMedia < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_imported_media, :variant_urls, :text, array: true, default: []
  end
end
