class RenameResearchJournalArticleText < ActiveRecord::Migration[6.1]
  def change
    rename_column :research_journal_articles, :text, :old_text
  end
end
