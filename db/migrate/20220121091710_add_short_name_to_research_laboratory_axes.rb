class AddShortNameToResearchLaboratoryAxes < ActiveRecord::Migration[6.1]
  def change
    add_column :research_laboratory_axes, :short_name, :string
  end
end
