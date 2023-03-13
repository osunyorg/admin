class CreateJoinTableUniversityPersonUniversityPersonCategory < ActiveRecord::Migration[7.0]
  def change
    create_table :university_people_categories, id: :uuid do |t|
      t.references :person, null: false, foreign_key: {to_table: :university_people}, type: :uuid
      t.references :category, null: false, foreign_key: {to_table: :university_person_categories}, type: :uuid
    end
  end
end
