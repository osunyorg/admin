class SetDefaultGithubDirectoriesInCommunicationWebsites < ActiveRecord::Migration[6.1]
  def change
    change_column_default :communication_websites, :authors_github_directory, from: nil, to: "authors"
    change_column_default :communication_websites, :posts_github_directory, from: nil, to: "posts"
  end
end
