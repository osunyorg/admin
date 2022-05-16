class CreateEducationDiplomas < ActiveRecord::Migration[6.1]
  def change
    create_table :education_diplomas, id: :uuid do |t|
      t.string :name
      t.string :short_name
      t.integer :level, default: 0
      t.string :slug
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_reference :education_programs, :diploma, type: :uuid
  end
end
