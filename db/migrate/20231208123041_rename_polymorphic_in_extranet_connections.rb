class RenamePolymorphicInExtranetConnections < ActiveRecord::Migration[7.1]
  def change
    rename_column :communication_extranet_connections, :object_id, :about_id
    rename_column :communication_extranet_connections, :object_type, :about_type
  end
end
