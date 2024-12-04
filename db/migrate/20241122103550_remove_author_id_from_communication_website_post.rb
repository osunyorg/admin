class RemoveAuthorIdFromCommunicationWebsitePost < ActiveRecord::Migration[7.2]
  def change
    remove_column :communication_website_posts, :author_id
  end
end
