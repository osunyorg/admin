class AddNodcCredentialsToCommunicationWebsites < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_websites, :nodc_access_key_id, :string
    add_column :communication_websites, :nodc_secret_access_key, :string
    add_column :communication_websites, :nodc_identifier, :string
  end
end
