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

    University::Person::Category.find_each do |category|
      about_id = category.original_id || category.id

      l10n = University::Person::Category::Localization.create(
        name: category.name,
        slug: category.slug,
        about_id: about_id,
        language_id: category.language_id,
        university_id: category.university_id,
        created_at: category.created_at
      )

      category.translate_contents!(l10n)

      category.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n
        new_permalink.save
      end

      l10n.save
    end
  end

  def down
    drop_table :university_person_category_localizations
  end
end
