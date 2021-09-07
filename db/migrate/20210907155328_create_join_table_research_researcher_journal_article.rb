class CreateJoinTableResearchResearcherJournalArticle < ActiveRecord::Migration[6.1]
  def change
    create_table :research_journal_articles_researchers do |t|
      t.references :researcher, null: false, foreign_key: {to_table: :research_researchers}, type: :uuid
      t.references :article, null: false, foreign_key: {to_table: :research_journal_articles}, type: :uuid
    end
  end
end
