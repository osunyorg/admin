class ChangeIndexOnResearchJournalArticleResearcher < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :research_journal_articles_researchers, column: :researcher_id
    add_foreign_key :research_journal_articles_researchers, :administration_members, column: :researcher_id
  end
end
