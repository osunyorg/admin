class CreateResearchLaboratoryAxisLocalization < ActiveRecord::Migration[7.1]
  def up
    create_table :research_laboratory_axis_localizations, id: :uuid do |t|
      t.text :meta_description
      t.string :name
      t.string :short_name
      t.text :summary

      t.references :about, foreign_key: { to_table: :research_laboratory_axes }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :research_laboratory_axis_localizations
  end
end
