class CreateResearchJournalLocalizations < ActiveRecord::Migration[7.1]
  def up
    change_column_null :research_journals, :language_id, true

    create_table :research_journal_localizations, id: :uuid do |t|
      t.string :issn
      t.text :meta_description
      t.text :summary
      t.string :title

      t.references :about, foreign_key: { to_table: :research_journals }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :research_journal_localizations
  end
end
