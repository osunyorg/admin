class RemoveUniversityPersonOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_column :university_people, :original_id
    remove_column :university_people, :language_id
    remove_column :university_people, :biography
    remove_column :university_people, :first_name
    remove_column :university_people, :last_name
    remove_column :university_people, :linkedin
    remove_column :university_people, :mastodon
    remove_column :university_people, :meta_description
    remove_column :university_people, :name
    remove_column :university_people, :picture_credit
    remove_column :university_people, :slug
    remove_column :university_people, :summary
    remove_column :university_people, :twitter
    remove_column :university_people, :url

  end
end
