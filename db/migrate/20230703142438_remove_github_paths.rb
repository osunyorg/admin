class RemoveGithubPaths < ActiveRecord::Migration[7.0]
  def change
    remove_column :communication_website_categories, :github_path
    remove_column :communication_website_menus, :github_path
    remove_column :communication_website_pages, :github_path
    remove_column :communication_website_posts, :github_path
  end
end
