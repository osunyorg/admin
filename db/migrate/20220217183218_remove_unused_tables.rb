class RemoveUnusedTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :communication_website_homes
    drop_table :communication_website_structures
  end
end
