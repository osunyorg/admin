class DropCommunicationWebsiteIndexPage < ActiveRecord::Migration[6.1]
  def change
    drop_table :communication_website_index_pages
  end
end
