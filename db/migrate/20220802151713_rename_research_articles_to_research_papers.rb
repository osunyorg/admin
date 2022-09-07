class RenameResearchArticlesToResearchPapers < ActiveRecord::Migration[6.1]
  def change
    rename_table :research_journal_articles, :research_journal_papers
    rename_table :research_journal_articles_researchers, :research_journal_papers_researchers
    rename_column :research_journal_papers_researchers, :article_id, :paper_id
  end
end
