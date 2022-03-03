class RemoveUnusedStaticPathsInWebsite < ActiveRecord::Migration[6.1]
  def change
    remove_column :communication_websites, :static_pathname_administrators
    remove_column :communication_websites, :static_pathname_authors
    remove_column :communication_websites, :static_pathname_posts
    remove_column :communication_websites, :static_pathname_programs
    remove_column :communication_websites, :static_pathname_research_articles
    remove_column :communication_websites, :static_pathname_research_volumes
    remove_column :communication_websites, :static_pathname_researchers
    remove_column :communication_websites, :static_pathname_staff
    remove_column :communication_websites, :static_pathname_teachers
  end
end
