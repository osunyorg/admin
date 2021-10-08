class AddFieldsToCommunicationWebsiteImportedPage < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_imported_pages, :title, :string
    add_column :communication_website_imported_pages, :content, :text
    add_column :communication_website_imported_pages, :path, :text
  end
end
