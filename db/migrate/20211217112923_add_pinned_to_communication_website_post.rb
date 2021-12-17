class AddPinnedToCommunicationWebsitePost < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_posts, :pinned, :boolean, default: false
  end
end
