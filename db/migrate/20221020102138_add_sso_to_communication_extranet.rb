class AddSsoToCommunicationExtranet < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_extranets, :has_sso, :boolean, default: false
    add_column :communication_extranets, :sso_inherit_from_university, :boolean, default: false
    add_column :communication_extranets, :sso_cert, :text
    add_column :communication_extranets, :sso_mapping, :jsonb
    add_column :communication_extranets, :sso_name_identifier_format, :string
    add_column :communication_extranets, :sso_provider, :integer, default: 0
    add_column :communication_extranets, :sso_target_url, :integer, default: 0
  end
end
