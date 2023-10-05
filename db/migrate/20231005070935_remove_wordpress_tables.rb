class RemoveWordpressTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :communication_website_imported_categories
    drop_table :communication_website_imported_authors
    drop_table :communication_website_imported_pages
    drop_table :communication_website_imported_posts
    drop_table :communication_website_imported_media
    drop_table :communication_website_imported_websites
  end
end
