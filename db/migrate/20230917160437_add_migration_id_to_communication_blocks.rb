class AddMigrationIdToCommunicationBlocks < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_blocks, :migration_identifier, :string
  end
end
