class RemoveResearchJournalOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :research_journals, :language_id
    remove_colum :research_journals, :issn
    remove_colum :research_journals, :meta_description
    remove_colum :research_journals, :summary
    remove_colum :research_journals, :title
    
  end
end
