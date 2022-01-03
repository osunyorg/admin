class ChangeGitFile < ActiveRecord::Migration[6.1]
  def change
    rename_column :communication_website_git_files, :github_path, :previous_path
    remove_column :communication_website_git_files, :manifest_identifier
    add_column :communication_website_git_files, :previous_sha, :string
    add_column :communication_website_git_files, :identifier, :string, default: 'static'
  end
end
