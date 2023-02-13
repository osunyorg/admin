class CreateResearchDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :research_documents, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :university_person, null: false, foreign_key: true, type: :uuid
      t.string :docid
      t.jsonb :data
      t.string :title
      t.string :url
      t.string :ref

      t.timestamps
    end
  end
end
