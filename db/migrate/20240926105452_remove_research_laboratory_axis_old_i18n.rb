class RemoveResearchLaboratoryAxisOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :research_laboratory_axes, :meta_description
    remove_colum :research_laboratory_axes, :name
    remove_colum :research_laboratory_axes, :short_name
    remove_colum :research_laboratory_axes, :text

  end
end
