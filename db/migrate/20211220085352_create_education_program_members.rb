class CreateEducationProgramMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :education_program_members, id: :uuid do |t|
      t.string :role
      t.references :member, null: false, foreign_key: { to_table: :administration_members }, type: :uuid
      t.references :program, null: false, foreign_key: { to_table: :education_programs }, type: :uuid

      t.timestamps
    end
  end
end
