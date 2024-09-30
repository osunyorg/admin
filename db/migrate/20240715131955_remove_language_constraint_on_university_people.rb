class RemoveLanguageConstraintOnUniversityPeople < ActiveRecord::Migration[7.1]
  def change
    change_column_null :university_people, :language_id, true
  end
end
