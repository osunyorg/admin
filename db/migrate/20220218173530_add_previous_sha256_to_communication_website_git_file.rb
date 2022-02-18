class AddPreviousSha256ToCommunicationWebsiteGitFile < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_git_files, :previous_sha256, :string
  end
end
