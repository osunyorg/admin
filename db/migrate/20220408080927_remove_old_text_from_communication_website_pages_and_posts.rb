class RemoveOldTextFromCommunicationWebsitePagesAndPosts < ActiveRecord::Migration[6.1]
  def change
    remove_column :communication_website_pages, :old_text
    remove_column :communication_website_posts, :old_text
  end
end
