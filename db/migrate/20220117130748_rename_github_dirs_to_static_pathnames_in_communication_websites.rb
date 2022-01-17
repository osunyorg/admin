class RenameGithubDirsToStaticPathnamesInCommunicationWebsites < ActiveRecord::Migration[6.1]
  def change
    rename_column :communication_websites, :authors_github_directory, :static_pathname_authors
    rename_column :communication_websites, :posts_github_directory, :static_pathname_posts
    rename_column :communication_websites, :programs_github_directory, :static_pathname_programs
    rename_column :communication_websites, :research_articles_github_directory, :static_pathname_research_articles
    rename_column :communication_websites, :research_volumes_github_directory, :static_pathname_research_volumes
    rename_column :communication_websites, :staff_github_directory, :static_pathname_staff
  end
end
