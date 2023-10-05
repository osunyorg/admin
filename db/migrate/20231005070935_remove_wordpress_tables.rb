class RemoveWordpressTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :communication_website_imported_media, force: :cascade
    drop_table :communication_website_imported_categories, force: :cascade
    drop_table :communication_website_imported_authors, force: :cascade
    drop_table :communication_website_imported_pages, force: :cascade
    drop_table :communication_website_imported_posts, force: :cascade
    drop_table :communication_website_imported_websites, force: :cascade
  end
end
