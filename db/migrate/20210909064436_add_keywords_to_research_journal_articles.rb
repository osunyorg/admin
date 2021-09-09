class AddKeywordsToResearchJournalArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :research_journal_articles, :keywords, :text
  end
end
