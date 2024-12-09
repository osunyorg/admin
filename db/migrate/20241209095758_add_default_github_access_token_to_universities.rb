class AddDefaultGithubAccessTokenToUniversities < ActiveRecord::Migration[7.2]
  def change
    add_column :universities, :default_github_access_token, :string
  end
end
