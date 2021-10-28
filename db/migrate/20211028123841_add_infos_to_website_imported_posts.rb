class AddInfosToWebsiteImportedPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_imported_posts, :author, :string
    add_column :communication_website_imported_posts, :categories, :jsonb
  end
end
