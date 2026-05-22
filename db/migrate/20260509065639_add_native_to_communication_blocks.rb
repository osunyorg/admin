class AddNativeToCommunicationBlocks < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_blocks, :native, :boolean, default: false
  end
end
