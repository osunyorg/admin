class RemoveUniversityPersonOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :university_people, :original_id
    remove_colum :university_people, :language_id
    remove_colum :university_people, :biography
    remove_colum :university_people, :first_name
    remove_colum :university_people, :last_name
    remove_colum :university_people, :linkedin
    remove_colum :university_people, :mastodon
    remove_colum :university_people, :meta_description
    remove_colum :university_people, :name
    remove_colum :university_people, :picture_credit
    remove_colum :university_people, :slug
    remove_colum :university_people, :summary
    remove_colum :university_people, :twitter
    remove_colum :university_people, :url
    
  end
end
