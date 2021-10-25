class AddIndexToCommunicationWebsiteImportedPages < ActiveRecord::Migration[6.1]
  def change
    add_index :communication_website_imported_pages, :identifier
  end
end
