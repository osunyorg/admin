class AddDeletedAtToResearchJournals < ActiveRecord::Migration[8.0]
  def change
    add_column :research_journals, :deleted_at, :datetime
    add_column :research_journal_localizations, :deleted_at, :datetime
  end
end
