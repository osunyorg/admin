class AddTitleToCommunicationBlocks < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_blocks, :title, :string
  end
end
