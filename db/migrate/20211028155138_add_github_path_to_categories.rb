class AddGithubPathToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_categories, :github_path, :text

  end
end
