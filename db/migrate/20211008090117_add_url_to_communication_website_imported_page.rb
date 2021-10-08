class AddUrlToCommunicationWebsiteImportedPage < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_imported_pages, :url, :text
  end
end
