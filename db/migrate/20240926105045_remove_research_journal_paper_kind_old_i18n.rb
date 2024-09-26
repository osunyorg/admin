class RemoveResearchJournalPaperKindOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :research_journal_paper_kinds, :slug
    remove_colum :research_journal_paper_kinds, :title
    
  end
end
