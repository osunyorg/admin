class AddDeletedAtToResearchLaboratories < ActiveRecord::Migration[8.0]
  def change
    add_column :research_laboratories, :deleted_at, :datetime
    add_column :research_laboratory_localizations, :deleted_at, :datetime
  end
end
