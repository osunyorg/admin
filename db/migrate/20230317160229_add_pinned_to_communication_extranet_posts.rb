class AddPinnedToCommunicationExtranetPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_extranet_posts, :pinned, :boolean, default: false
  end
end
