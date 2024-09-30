class CreateEducationSchoolLocalization < ActiveRecord::Migration[7.1]
  def up
    change_column_null :education_schools, :language_id, true

    create_table :education_school_localizations, id: :uuid do |t|
      t.string :meta_description
      t.boolean :published, default: false
      t.datetime :published_at
      t.string :slug
      t.text :summary
      t.string :name
      t.string :url

      t.references :about, foreign_key: { to_table: :education_schools }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :education_school_localizations
  end
end
