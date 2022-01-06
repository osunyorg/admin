class CreateEducationProgramRolePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :education_program_role_people, id: :uuid do |t|
      t.integer :position
      t.references :person, null: false, foreign_key: { to_table: :university_people }, type: :uuid
      t.references :role, null: false, foreign_key: { to_table: :education_program_roles }, type: :uuid

      t.timestamps
    end
  end
end
