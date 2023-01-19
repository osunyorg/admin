class CreateResearchJournalPaperKinds < ActiveRecord::Migration[7.0]
  def change
    create_table :research_journal_paper_kinds, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :journal, null: false, foreign_key: {to_table: :research_journals}, type: :uuid
      t.string :title
      t.string :slug

      t.timestamps
    end
  end
end
