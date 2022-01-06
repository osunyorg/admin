class CreateEducationProgramRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :education_program_roles, id: :uuid do |t|
      t.string :title
      t.integer :position
      t.references :program, null: false, foreign_key: { to_table: :education_programs }, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
