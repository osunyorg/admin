class RenameTextInCommunicationWebsitePosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :communication_website_posts, :text, :old_text
  end
end
