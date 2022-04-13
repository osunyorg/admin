class AddTextToResearchJournalVolume < ActiveRecord::Migration[6.1]
  def change
    add_column :research_journal_volumes, :text, :text
  end
end
