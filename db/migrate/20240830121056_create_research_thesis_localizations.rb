class CreateResearchThesisLocalizations < ActiveRecord::Migration[7.1]
  def up
    create_table :research_thesis_localizations, id: :uuid do |t|
      t.text :abstract
      t.string :title

      t.references :about, foreign_key: { to_table: :research_theses }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :research_thesis_localizations
  end
end
