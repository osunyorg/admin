class AddSummaryToResearchPapers < ActiveRecord::Migration[7.0]
  def change
    add_column :research_journal_papers, :summary, :text
  end
end
