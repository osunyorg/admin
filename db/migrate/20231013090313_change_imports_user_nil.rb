class ChangeImportsUserNil < ActiveRecord::Migration[7.0]
  def change
    change_column :imports, :user_id, :uuid, null: true
  end
end
