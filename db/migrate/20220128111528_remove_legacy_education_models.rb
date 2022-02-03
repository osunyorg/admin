class RemoveLegacyEducationModels < ActiveRecord::Migration[6.1]
  def change
    drop_table :education_school_administrators
    drop_table :education_program_teachers
    drop_table :education_program_role_people
    drop_table :education_program_roles
  end
end
