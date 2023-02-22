class AddI18nInfosToUniversityPeople < ActiveRecord::Migration[7.0]
  def change
    add_reference :university_people, :language, foreign_key: true, type: :uuid

    University::Person.reset_column_information
    University.all.find_each do |university|
      university.people.update_all(language_id: university.default_language_id)
    end

    change_column_null :university_people, :language_id, false
    add_reference :university_people, :original, foreign_key: {to_table: :university_people}, type: :uuid
  end
end
