class AddDeletedAtToCommunicationWebsitePageLocalizations < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_page_localizations, :deleted_at, :datetime
    add_index :communication_website_page_localizations, :deleted_at
  end
end
