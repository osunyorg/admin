class AddServerAdminToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :server_admin, :boolean, default: false
    User.where(role: 30).update_all(server_admin: true)
  end
end
