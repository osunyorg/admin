class RemoveResearchLaboratoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :research_laboratories, :address_additional
    remove_column :research_laboratories, :address_name
    remove_column :research_laboratories, :name

  end
end
