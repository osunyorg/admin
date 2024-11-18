class RenameCommunicationWebsitePostsUniversityPersons < ActiveRecord::Migration[7.2]
  def change
    rename_table :communication_website_posts_university_persons, :communication_website_posts_university_people
  end
end
