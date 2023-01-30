class RenamePaperKindIdToKindId < ActiveRecord::Migration[7.0]
  def change
    rename_column :research_journal_papers, :paper_kind_id, :kind_id
  end
end
