class AddAdditionalAddressToAdministrationLocation < ActiveRecord::Migration[7.1]
  def change
    add_column :administration_locations, :address_additional, :string
    add_column :administration_locations, :address_name, :string
  end
end
