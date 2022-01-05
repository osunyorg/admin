class RemoveEducationProgramsTeachersJoinTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :education_programs_teachers
  end
end
