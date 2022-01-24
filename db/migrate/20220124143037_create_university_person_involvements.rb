class CreateUniversityPersonInvolvements < ActiveRecord::Migration[6.1]
  def change
    create_table :university_person_involvements, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :person, null: false, foreign_key: { to_table: :university_people }, type: :uuid
      t.integer :kind
      t.references :target, null: false, polymorphic: true, type: :uuid
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
