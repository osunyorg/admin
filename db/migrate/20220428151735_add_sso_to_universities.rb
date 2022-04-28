class AddSsoToUniversities < ActiveRecord::Migration[6.1]
  def change
    add_column :universities, :has_sso, :boolean, default: false
    add_column :universities, :sso_provider, :integer, default: 0
    add_column :universities, :sso_target_url, :string
    add_column :universities, :sso_cert, :text
    add_column :universities, :sso_name_identifier_format, :string
    add_column :universities, :sso_mapping, :jsonb
  end
end
