class RemoveResearchJournalPaperOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :research_journal_papers, :abstract
    remove_colum :research_journal_papers, :authors_list
    remove_colum :research_journal_papers, :keywords
    remove_colum :research_journal_papers, :meta_description
    remove_colum :research_journal_papers, :published
    remove_colum :research_journal_papers, :published_at
    remove_colum :research_journal_papers, :slug
    remove_colum :research_journal_papers, :summary
    remove_colum :research_journal_papers, :title

  end
end
