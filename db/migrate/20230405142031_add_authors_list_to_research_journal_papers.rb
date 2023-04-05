class AddAuthorsListToResearchJournalPapers < ActiveRecord::Migration[7.0]
  def change
    add_column :research_journal_papers, :authors_list, :text
  end
end
