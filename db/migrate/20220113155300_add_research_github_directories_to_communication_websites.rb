class AddResearchGithubDirectoriesToCommunicationWebsites < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_websites, :research_volumes_github_directory, :string, default: 'volumes'
    add_column :communication_websites, :research_articles_github_directory, :string, default: 'articles'
  end
end
