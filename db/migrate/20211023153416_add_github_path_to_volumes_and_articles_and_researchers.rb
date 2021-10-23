class AddGithubPathToVolumesAndArticlesAndResearchers < ActiveRecord::Migration[6.1]
  def change
    add_column :research_journal_articles, :github_path, :text
    add_column :research_journal_volumes, :github_path, :text
    add_column :research_researchers, :github_path, :text
  end
end
