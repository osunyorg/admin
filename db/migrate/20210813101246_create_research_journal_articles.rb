class CreateResearchJournalArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :research_journal_articles, id: :uuid do |t|
      t.string :title
      t.text :text
      t.datetime :published_at
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :research_journal, null: false, foreign_key: true, type: :uuid
      t.references :research_journal_volume, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
