class CreateCommunicationWebsitePostCategoryLocalizations < ActiveRecord::Migration[7.1]
  def up
    create_table :communication_website_post_category_localizations, id: :uuid do |t|
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.string :name
      t.text :meta_description
      t.string :slug
      t.string :path
      t.text :summary
      
      t.references :about, foreign_key: { to_table: :communication_website_post_categories }, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :communication_website, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    Communication::Website::Post::Category.find_each do |object|
      puts "Migration category #{object.id}"

      about_id = object.original_id || object.id

      l10n = Communication::Website::Post::Category::Localization.create(
        featured_image_alt: object.featured_image_alt,
        featured_image_credit: object.featured_image_credit,
        meta_description: object.meta_description,
        slug: object.slug,
        path: object.path,
        summary: object.summary,
        name: object.name,
        about_id: about_id,
        language_id: object.language_id,
        communication_website_id: object.communication_website_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      object.translate_contents!(l10n)
      object.translate_other_attachments(l10n)

      object.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n
        new_permalink.save
      end

      l10n.save

    end
  end

  def down
    drop_table :communication_website_post_category_localizations
  end
end
