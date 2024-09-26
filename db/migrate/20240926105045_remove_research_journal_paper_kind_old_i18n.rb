class RemoveResearchJournalPaperKindOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :research_journal_paper_kinds, :slug
    remove_column :research_journal_paper_kinds, :title

  end
end
