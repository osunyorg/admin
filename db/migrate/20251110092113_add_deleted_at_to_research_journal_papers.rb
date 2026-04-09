class AddDeletedAtToResearchJournalPapers < ActiveRecord::Migration[8.0]
  def change
    add_column :research_journal_papers, :deleted_at, :datetime
    add_column :research_journal_paper_localizations, :deleted_at, :datetime
  end
end
