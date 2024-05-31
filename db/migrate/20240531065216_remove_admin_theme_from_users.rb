class RemoveAdminThemeFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :admin_theme
  end
end
