class CreateResearchLaboratoryLocalization < ActiveRecord::Migration[7.1]
  def up
    create_table :research_laboratory_localizations, id: :uuid do |t|
      t.string :address_additional
      t.string :address_name
      t.string :name

      t.references :about, foreign_key: { to_table: :research_laboratories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :research_laboratory_localizations
  end
end
