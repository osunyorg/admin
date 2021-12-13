class RemovePathFromCommunicationPost < ActiveRecord::Migration[6.1]
  def change
    remove_column :communication_website_posts, :path
  end
end
