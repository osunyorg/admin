class CreateResearchJournalPaperLocalizations < ActiveRecord::Migration[7.1]
  def up
    create_table :research_journal_paper_localizations, id: :uuid do |t|
      t.string :abstract
      t.text :authors_list
      t.text :keywords
      t.text :meta_description
      t.boolean :published, default: false
      t.datetime :published_at
      t.string :slug
      t.text :summary
      t.string :title

      t.references :about, foreign_key: { to_table: :research_journal_papers }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :research_journal_paper_localizations
  end
end
