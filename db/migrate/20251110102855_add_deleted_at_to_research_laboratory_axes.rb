class AddDeletedAtToResearchLaboratoryAxes < ActiveRecord::Migration[8.0]
  def change
    add_column :research_laboratory_axes, :deleted_at, :datetime
    add_column :research_laboratory_axis_localizations, :deleted_at, :datetime
  end
end
