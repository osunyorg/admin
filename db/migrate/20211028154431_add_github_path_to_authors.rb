class AddGithubPathToAuthors < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_authors, :github_path, :text
  end
end
