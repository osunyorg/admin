class AddManifestIdentifierToCommunicationWebsiteGithubFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_github_files, :manifest_identifier, :string
  end
end
