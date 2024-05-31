class RemoveAdminThemeFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :admin_theme, :integer, default: 1
  end
end
