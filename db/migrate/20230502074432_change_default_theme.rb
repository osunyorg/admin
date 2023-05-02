class ChangeDefaultTheme < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :admin_theme, :integer, default: 1 
  end
end
