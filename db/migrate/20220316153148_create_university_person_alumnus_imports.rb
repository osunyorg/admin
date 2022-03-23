class CreateUniversityPersonAlumnusImports < ActiveRecord::Migration[6.1]
  def change
    create_table :university_person_alumnus_imports, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
