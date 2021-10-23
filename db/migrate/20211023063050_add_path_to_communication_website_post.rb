class AddPathToCommunicationWebsitePost < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_posts, :path, :text
    add_column :communication_website_posts, :github_path, :text
    add_column :communication_website_pages, :github_path, :text
  end
end
