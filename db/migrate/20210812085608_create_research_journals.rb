class CreateResearchJournals < ActiveRecord::Migration[6.1]
  def change
    create_table :research_journals, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
