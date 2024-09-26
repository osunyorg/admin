class RemoveUniversityPersonInvolvementI18n < ActiveRecord::Migration[7.1]
  def change
     remove_colum :university_person_involvements, :original_id
     remove_colum :university_person_involvements, :language_id
     remove_colum :university_person_involvements, :description

  end
end
