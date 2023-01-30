class AddPaperKindToResearchJournalPaper < ActiveRecord::Migration[7.0]
  def change
    add_reference :research_journal_papers, :paper_kind, foreign_key: {to_table: :research_journal_paper_kinds}, type: :uuid
  end
end
