class AddPublishedAndPositionToResearchJournalArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :research_journal_articles, :published, :boolean, default: false
    add_column :research_journal_articles, :position, :integer
  end
end
