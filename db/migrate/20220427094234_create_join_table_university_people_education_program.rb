class CreateJoinTableUniversityPeopleEducationProgram < ActiveRecord::Migration[6.1]
  def change
    create_join_table :university_people, :education_programs, column_options: {type: :uuid} do |t|
      t.index [:"university_person_id", :"education_program_id"], name: 'index_person_program'
      t.index [:"education_program_id", :"university_person_id"], name: 'index_program_person'
    end
  end
end
