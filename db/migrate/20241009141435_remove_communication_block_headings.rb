class RemoveCommunicationBlockHeadings < ActiveRecord::Migration[7.1]
  def change
    remove_column :communication_blocks, :heading_id
    drop_table :communication_block_headings
  end
end
