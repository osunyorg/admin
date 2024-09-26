class RemoveResearchLaboratoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :research_laboratories, :address_additional
    remove_colum :research_laboratories, :address_name
    remove_colum :research_laboratories, :name

  end
end
