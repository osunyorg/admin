class RemoveSha256FromCommunicationWebsiteGitFile < ActiveRecord::Migration[6.1]
  def change
    remove_column :communication_website_git_files, :previous_sha256
  end
end
