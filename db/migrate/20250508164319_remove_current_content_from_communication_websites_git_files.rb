class RemoveCurrentContentFromCommunicationWebsitesGitFiles < ActiveRecord::Migration[8.0]
  def change
    remove_column :communication_website_git_files, :current_content, :text
  end
end
