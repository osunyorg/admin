class AddDatesToResearchPapers < ActiveRecord::Migration[7.0]
  def change
    add_column :research_journal_papers, :received_at, :date
    add_column :research_journal_papers, :accepted_at, :date
  end
end
