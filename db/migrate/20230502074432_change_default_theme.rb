class ChangeDefaultTheme < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:users, :admin_theme, from: 0, to: 1)
  end
end
