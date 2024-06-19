class RemoveUnusedI18nInfoToResearchJournalChildren < ActiveRecord::Migration[7.1]
  def change
    remove_column :research_journal_volumes, :language_id, :uuid
    remove_column :research_journal_papers, :language_id, :uuid
    remove_column :research_journal_paper_kinds, :language_id, :uuid
    remove_column :research_journal_paper_kinds, :original_id, :uuid
  end
end
