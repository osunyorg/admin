class AddFieldsToResearchJournalArticle < ActiveRecord::Migration[6.1]
  def change
    add_reference :research_journal_articles, :updated_by, foreign_key: {to_table: :users}, type: :uuid
    change_column :research_journal_articles, :published_at, :date
  end
end
