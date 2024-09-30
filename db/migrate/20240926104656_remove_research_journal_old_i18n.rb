class RemoveResearchJournalOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :research_journals, :language_id
    remove_column :research_journals, :issn
    remove_column :research_journals, :meta_description
    remove_column :research_journals, :summary
    remove_column :research_journals, :title

  end
end
