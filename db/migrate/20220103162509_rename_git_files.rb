class RenameGitFiles < ActiveRecord::Migration[6.1]
  def change
    rename_table :communication_website_github_files, :communication_website_git_files
  end
end
