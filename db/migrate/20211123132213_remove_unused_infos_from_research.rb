class RemoveUnusedInfosFromResearch < ActiveRecord::Migration[6.1]
  def change
    remove_column :research_researchers, :old_biography
    remove_column :research_journal_articles, :github_path
    remove_column :research_journal_volumes, :github_path
  end
end
