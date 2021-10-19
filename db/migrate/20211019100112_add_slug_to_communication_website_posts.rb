class AddSlugToCommunicationWebsitePosts < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_posts, :slug, :text
  end
end
