class AddMigrationIdentifierToCommunicationBlockHeadings < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_block_headings, :migration_identifier, :string
  end
end
