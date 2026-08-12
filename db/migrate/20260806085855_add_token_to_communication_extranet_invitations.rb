class AddTokenToCommunicationExtranetInvitations < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_extranet_invitations, :token, :string
    add_index :communication_extranet_invitations, :token, unique: true
  end
end
