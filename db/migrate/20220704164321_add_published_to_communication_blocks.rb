class AddPublishedToCommunicationBlocks < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_blocks, :published, :boolean, default: true
  end
end
