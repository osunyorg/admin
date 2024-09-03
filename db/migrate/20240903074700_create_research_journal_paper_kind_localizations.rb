class CreateResearchJournalPaperKindLocalizations < ActiveRecord::Migration[7.1]
  def up
    create_table :research_journal_paper_kind_localizations, id: :uuid do |t|
      t.string :slug
      t.string :title

      t.references :about, foreign_key: { to_table: :research_journal_paper_kinds }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :research_journal_paper_kind_localizations
  end
end
