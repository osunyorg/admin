class RemoveUniversityPersonExperienceOldI18n < ActiveRecord::Migration[7.1]
  def change
     remove_colum :university_person_experiences, :description
  end
end
