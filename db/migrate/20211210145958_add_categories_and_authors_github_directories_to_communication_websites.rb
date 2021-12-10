class AddCategoriesAndAuthorsGithubDirectoriesToCommunicationWebsites < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_websites, :authors_github_directory, :string
    add_column :communication_websites, :posts_github_directory, :string
  end
end
