class CreateJoinTableUniversityPeopleEducationAcademicYear < ActiveRecord::Migration[6.1]
  def change
    create_join_table :university_people, :education_academic_years, column_options: {type: :uuid} do |t|
      t.index [:"university_person_id", :"education_academic_year_id"], name: 'index_person_academic_year'
      t.index [:"education_academic_year_id", :"university_person_id"], name: 'index_academic_year_person'
    end
  end
end
