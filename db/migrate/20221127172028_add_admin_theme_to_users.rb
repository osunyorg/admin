class AddAdminThemeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin_theme, :integer, default: 0
  end
end
