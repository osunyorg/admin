class AddI18nInfosToEducationSchools < ActiveRecord::Migration[7.1]
   def up
    add_reference :education_schools, :language, foreign_key: true, type: :uuid
    add_reference :education_schools, :original, foreign_key: {to_table: :education_schools}, type: :uuid

    Education::School.reset_column_information
    University.all.find_each do |university|
      university.schools.update_all(language_id: university.default_language_id)
    end
  end

  def down
    remove_reference :education_schools, :language
    remove_reference :education_schools, :original
  end
end
