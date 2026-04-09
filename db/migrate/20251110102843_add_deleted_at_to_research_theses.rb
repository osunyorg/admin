class AddDeletedAtToResearchTheses < ActiveRecord::Migration[8.0]
  def change
    add_column :research_theses, :deleted_at, :datetime
    add_column :research_thesis_localizations, :deleted_at, :datetime
  end
end
