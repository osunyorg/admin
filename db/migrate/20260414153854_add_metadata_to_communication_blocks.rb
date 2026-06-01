class AddMetadataToCommunicationBlocks < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_blocks, :metadata, :jsonb
  end
end
