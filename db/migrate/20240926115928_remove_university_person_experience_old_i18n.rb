class RemoveUniversityPersonExperienceOldI18n < ActiveRecord::Migration[7.1]
  def change
     remove_column :university_person_experiences, :description
  end
end
