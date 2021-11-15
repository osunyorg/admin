class CreateEducationTeacher < ActiveRecord::Migration[6.1]
  def change
    create_table :education_teachers, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :first_name
      t.string :last_name
      t.string :slug
      t.text :github_path
      t.references :user, null: true, foreign_key: true, type: :uuid


      t.timestamps
    end
  end
end
