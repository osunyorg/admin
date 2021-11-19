class AddGithubPathToHomes < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_homes, :github_path, :text
  end
end
