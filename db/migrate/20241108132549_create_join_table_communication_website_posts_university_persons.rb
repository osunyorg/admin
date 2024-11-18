class CreateJoinTableCommunicationWebsitePostsUniversityPersons < ActiveRecord::Migration[7.2]
  def change
    create_join_table :communication_website_posts, :university_persons, column_options: {type: :uuid} do |t|
      t.index [:communication_website_post_id, :university_person_id], name: 'post_person'
      t.index [:university_person_id, :communication_website_post_id], name: 'person_post'
    end
  end
end
