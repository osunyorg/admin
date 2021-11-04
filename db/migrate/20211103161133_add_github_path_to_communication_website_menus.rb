class AddGithubPathToCommunicationWebsiteMenus < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_menus, :github_path, :text
  end
end
