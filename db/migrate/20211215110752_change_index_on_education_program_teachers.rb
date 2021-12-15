class ChangeIndexOnEducationProgramTeachers < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :education_programs_teachers, :administration_members, column: :education_teacher_id

  end
end
