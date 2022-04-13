class CreateUniversityPersonExperiences < ActiveRecord::Migration[6.1]
  def change
    create_table :university_person_experiences, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :person, null: false, foreign_key: {to_table: :university_people}, type: :uuid
      t.references :organization, null: false, foreign_key: {to_table: :university_organizations}, type: :uuid
      t.text :description
      t.integer :from_year
      t.integer :to_year

      t.timestamps
    end
  end
end
