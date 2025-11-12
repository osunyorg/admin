class AddDeletedAtToResearchJournalVolumes < ActiveRecord::Migration[8.0]
  def change
    add_column :research_journal_volumes, :deleted_at, :datetime
    add_column :research_journal_volume_localizations, :deleted_at, :datetime
  end
end
