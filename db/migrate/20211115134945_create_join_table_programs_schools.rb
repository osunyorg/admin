class CreateJoinTableProgramsSchools < ActiveRecord::Migration[6.1]
  def change
    create_join_table :education_programs, :education_schools, column_options: {type: :uuid} do |t|
      t.index [:education_program_id, :education_school_id], name: 'program_school'
      t.index [:education_school_id, :education_program_id], name: 'school_program'
    end
  end
end
