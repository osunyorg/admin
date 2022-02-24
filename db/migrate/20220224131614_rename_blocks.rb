class RenameBlocks < ActiveRecord::Migration[6.1]
  def change
    rename_table :communication_website_blocks, :communication_blocks
  end
end
