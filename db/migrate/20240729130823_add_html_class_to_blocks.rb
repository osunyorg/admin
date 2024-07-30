class AddHtmlClassToBlocks < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_blocks, :html_class, :string
  end
end
