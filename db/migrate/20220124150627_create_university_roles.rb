class CreateUniversityRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :university_roles, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :target, polymorphic: true, type: :uuid
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
