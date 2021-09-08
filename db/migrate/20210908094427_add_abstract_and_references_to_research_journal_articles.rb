class AddAbstractAndReferencesToResearchJournalArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :research_journal_articles, :abstract, :text
    add_column :research_journal_articles, :references, :text
  end
end
