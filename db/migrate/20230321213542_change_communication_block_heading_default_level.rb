class ChangeCommunicationBlockHeadingDefaultLevel < ActiveRecord::Migration[7.0]
  def change
    change_column :communication_block_headings, :level, :integer, default: 2
  end
end
