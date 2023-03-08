class AddFieldsToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :university_organizations, :address_name, :string
    add_column :university_organizations, :address_additional, :string
  end
end
