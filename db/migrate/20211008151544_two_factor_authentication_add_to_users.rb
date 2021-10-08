class TwoFactorAuthenticationAddToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :mobile_phone, :string
    add_column :users, :second_factor_attempts_count, :integer, default: 0
    add_column :users, :encrypted_otp_secret_key, :string
    add_column :users, :encrypted_otp_secret_key_iv, :string
    add_column :users, :encrypted_otp_secret_key_salt, :string
    add_column :users, :direct_otp, :string
    add_column :users, :direct_otp_sent_at, :datetime
    add_column :users, :totp_timestamp, :timestamp

    add_index :users, :encrypted_otp_secret_key, unique: true
  end
end
