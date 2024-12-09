class RenameSearch < ActiveRecord::Migration[7.2]
  def change
    rename_table :search, :search_index
  end
end
