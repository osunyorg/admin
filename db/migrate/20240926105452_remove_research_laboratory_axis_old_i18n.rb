class RemoveResearchLaboratoryAxisOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :research_laboratory_axes, :meta_description
    remove_column :research_laboratory_axes, :name
    remove_column :research_laboratory_axes, :short_name
    remove_column :research_laboratory_axes, :text

  end
end
