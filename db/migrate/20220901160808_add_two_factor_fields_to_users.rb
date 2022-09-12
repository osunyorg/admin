class AddTwoFactorFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :direct_otp_delivery_method, :string
  end
end
