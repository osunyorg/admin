class AddDoiToResearchJournalPaper < ActiveRecord::Migration[7.0]
  def change
    add_column :research_journal_papers, :doi, :string
  end
end
