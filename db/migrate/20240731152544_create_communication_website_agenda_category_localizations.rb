class CreateCommunicationWebsiteAgendaCategoryLocalizations < ActiveRecord::Migration[7.1]
  def up
    change_column_null :communication_website_agenda_categories, :language_id, true

    create_table :communication_website_agenda_category_localizations, id: :uuid do |t|
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.text :meta_description
      t.string :name
      t.string :path
      t.string :slug, index: true
      t.text :summary

      t.references :about, foreign_key: { to_table: :communication_website_agenda_categories }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    Communication::Website::Agenda::Category.find_each do |category|
      about_id = category.original_id || category.id

      l10n = Communication::Website::Agenda::Category::Localization.create(
        featured_image_alt: category.featured_image_alt,
        featured_image_credit: category.featured_image_credit,
        meta_description: category.meta_description,
        name: category.name,
        slug: category.slug,
        path: category.path,

        about_id: about_id,
        language_id: category.language_id,
        communication_website_id: category.communication_website_id,
        university_id: category.university_id,

        created_at: category.created_at
      )

      category.translate_contents!(l10n)
      category.translate_attachment(l10n, :featured_image)

      category.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n
        new_permalink.save
      end

      l10n.save
    end
  end

  def down
    drop_table :communication_website_agenda_category_localizations
  end
end
