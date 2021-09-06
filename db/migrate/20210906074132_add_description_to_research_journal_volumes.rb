class AddDescriptionToResearchJournalVolumes < ActiveRecord::Migration[6.1]
  def change
    add_column :research_journal_volumes, :description, :text
  end
end
