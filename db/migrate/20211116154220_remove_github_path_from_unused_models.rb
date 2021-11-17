class RemoveGithubPathFromUnusedModels < ActiveRecord::Migration[6.1]
  def change
    remove_column :research_researchers, :github_path
    remove_column :education_teachers, :github_path
  end
end
