class CreateEducationSchoolAdministrators < ActiveRecord::Migration[6.1]
  def change
    create_table :education_school_administrators, id: :uuid do |t|
      t.text :description
      t.references :school, null: false, foreign_key: { to_table: :education_schools }, type: :uuid
      t.references :person, null: false, foreign_key: { to_table: :university_people }, type: :uuid

      t.timestamps
    end
  end
end
