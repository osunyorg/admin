class RemoveSourceFromConnections < ActiveRecord::Migration[7.0]
  def change
    remove_column :communication_website_connections, :source_id
    remove_column :communication_website_connections, :source_type
  end
end
