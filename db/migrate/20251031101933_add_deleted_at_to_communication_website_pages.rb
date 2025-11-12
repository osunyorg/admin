class AddDeletedAtToCommunicationWebsitePages < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_pages, :deleted_at, :datetime
    add_index :communication_website_pages, :deleted_at
  end
end
