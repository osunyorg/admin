class CreateResearchTheses < ActiveRecord::Migration[6.1]
  def change
    create_table :research_theses, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :research_laboratory, null: false, foreign_key: true, type: :uuid
      t.references :author, null: false, foreign_key: { to_table: :university_people }, type: :uuid
      t.references :director, null: false, foreign_key: { to_table: :university_people }, type: :uuid
      t.string :title
      t.text :abstract
      t.date :started_at
      t.boolean :completed, default: false
      t.date :completed_at

      t.timestamps
    end
  end
end
