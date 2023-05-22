class RenameConnectionAttributes < ActiveRecord::Migration[7.0]
  def change
    rename_column :communication_website_connections, :object_type,  :indirect_object_type
    rename_column :communication_website_connections, :object_id,    :indirect_object_id
    rename_column :communication_website_connections, :source_type,  :direct_source_type
    rename_column :communication_website_connections, :source_id,    :direct_source_id
  end
end
