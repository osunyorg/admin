class DeleteIndexOnDeletedAt < ActiveRecord::Migration[8.0]
  def change
    remove_index :communication_website_pages, :deleted_at
    remove_index :communication_website_page_localizations, :deleted_at
  end
end
