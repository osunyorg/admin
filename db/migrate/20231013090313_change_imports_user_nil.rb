class ChangeImportsUserNil < ActiveRecord::Migration[7.0]
  def change
    change_column_null :imports, :user_id, true
  end
end
