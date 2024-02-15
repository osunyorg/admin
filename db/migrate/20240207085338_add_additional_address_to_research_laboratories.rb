class AddAdditionalAddressToResearchLaboratories < ActiveRecord::Migration[7.1]
  def change
    add_column :research_laboratories, :address_name, :string
    add_column :research_laboratories, :address_additional, :string
  end
end
