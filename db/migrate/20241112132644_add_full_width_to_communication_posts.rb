class AddFullWidthToCommunicationPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_posts, :full_width, :boolean, default: false
  end
end
