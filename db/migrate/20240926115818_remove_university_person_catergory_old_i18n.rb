class RemoveUniversityPersonCatergoryOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :university_person_categories, :original_id
    remove_colum :university_person_categories, :language_id
    remove_colum :university_person_categories, :name
    remove_colum :university_person_categories, :slug
    
  end
end
