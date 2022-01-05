class CreateEducationProgramTeachers < ActiveRecord::Migration[6.1]
  def change
    create_table :education_program_teachers, id: :uuid do |t|
      t.text :description
      t.references :program, null: false, foreign_key: { to_table: :education_programs }, type: :uuid
      t.references :person, null: false, foreign_key: { to_table: :university_people }, type: :uuid

      t.timestamps
    end
  end
end
