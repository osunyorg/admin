class AddIdentifierToCommunicationWebsiteImportedPage < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_imported_pages, :identifier, :string
    add_column :communication_website_imported_pages, :excerpt, :text
  end
end
