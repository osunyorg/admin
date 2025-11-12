class AddDeletedAtToResearchJournalPaperKinds < ActiveRecord::Migration[8.0]
  def change
    add_column :research_journal_paper_kinds, :deleted_at, :datetime
    add_column :research_journal_paper_kind_localizations, :deleted_at, :datetime
  end
end
