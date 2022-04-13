class AddDescriptionToResearchJournalArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :research_journal_articles, :description, :text

  end
end
