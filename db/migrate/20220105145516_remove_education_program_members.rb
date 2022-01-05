class RemoveEducationProgramMembers < ActiveRecord::Migration[6.1]
  def change
    drop_table :education_program_members
  end
end
