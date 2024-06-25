class AddDeuxfleursCredentialsToCommunicationWebsites < ActiveRecord::Migration[7.1]
  def change
    add_column :communication_websites, :deuxfleurs_access_key_id, :string
    add_column :communication_websites, :deuxfleurs_secret_access_key, :string
  end
end
