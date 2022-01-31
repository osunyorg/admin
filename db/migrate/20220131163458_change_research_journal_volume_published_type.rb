class ChangeResearchJournalVolumePublishedType < ActiveRecord::Migration[6.1]
  def change
    change_column :research_journal_volumes, :published_at, :datetime
  end
end
