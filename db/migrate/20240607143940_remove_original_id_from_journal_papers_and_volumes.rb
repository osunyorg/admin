class RemoveOriginalIdFromJournalPapersAndVolumes < ActiveRecord::Migration[7.1]
  def change
    remove_column :research_journal_volumes, :original_id
    remove_column :research_journal_papers, :original_id
  end
end
