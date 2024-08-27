class CreateEducationDiplomaLocalization < ActiveRecord::Migration[7.1]
  def up
    change_column_null :education_diplomas, :language_id, true

    create_table :education_diploma_localizations, id: :uuid do |t|
      t.text :duration
      t.string :name
      t.string :short_name
      t.string :slug
      t.text :summary
      
      t.references :about, foreign_key: { to_table: :education_diplomas }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :education_diploma_localizations
  end
end
