class CreateUniversityPersonCategoryLocalizations < ActiveRecord::Migration[7.1]
  def up
    change_column_null :university_person_categories, :language_id, true

    create_table :university_person_category_localizations, id: :uuid do |t|
      t.string  :name
      t.string  :slug, index: true

      t.references :about, foreign_key: { to_table: :university_person_categories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :university_person_category_localizations
  end
end
