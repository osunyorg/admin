class AddElementsToCommunicationWebsiteGitFiles < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_git_files, :current_path, :string
    add_column :communication_website_git_files, :current_sha, :string
    add_column :communication_website_git_files, :current_content, :text
    add_column :communication_website_git_files, :desynchronized, :boolean
    add_column :communication_website_git_files, :desynchronized_at, :datetime
  end
end
