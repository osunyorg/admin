class CreateJoinTableProgramsTeachers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :education_programs, :education_teachers, column_options: {type: :uuid} do |t|
      t.index [:education_program_id, :education_teacher_id], name: 'program_teacher'
      t.index [:education_teacher_id, :education_program_id], name: 'teacher_program'
    end
  end
end
