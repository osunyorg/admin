class CreatePrograms < ActiveRecord::Migration[6.1]
  def change
    create_table :programs, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.integer :level
      t.integer :capacity
      t.integer :ects
      t.boolean :continuing
      t.text :prerequisites
      t.text :objectives
      t.text :duration
      t.text :registration
      t.text :pedagogy
      t.text :evaluation
      t.text :accessibility

      t.timestamps
    end
  end
end
