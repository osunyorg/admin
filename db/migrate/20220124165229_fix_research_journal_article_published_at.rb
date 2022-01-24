class FixResearchJournalArticlePublishedAt < ActiveRecord::Migration[6.1]
  def change
    change_column :research_journal_articles, :published_at, :datetime
  end
end
