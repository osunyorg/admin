class AddDeletedAtToCommunicationPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_posts, :deleted_at, :datetime
    add_column :communication_website_post_localizations, :deleted_at, :datetime
  end
end
