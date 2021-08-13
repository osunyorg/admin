class CreateResearchJournalVolumes < ActiveRecord::Migration[6.1]
  def change
    create_table :research_journal_volumes, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :research_journal, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.integer :number
      t.datetime :published_at

      t.timestamps
    end
  end
end
