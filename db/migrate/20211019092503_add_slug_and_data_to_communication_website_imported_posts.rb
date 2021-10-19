class AddSlugAndDataToCommunicationWebsiteImportedPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_imported_posts, :slug, :text
    add_column :communication_website_imported_posts, :data, :jsonb
  end
end
