class AddParentIdToCommunicationWebsiteImportedPages < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_imported_pages, :parent, :string
  end
end
