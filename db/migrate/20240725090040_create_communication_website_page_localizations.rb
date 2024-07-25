class CreateCommunicationWebsitePageLocalizations < ActiveRecord::Migration[7.1]
  def up
    # Warning
    # - Gérer correctement les special pages

    change_column_null :communication_website_pages, :language_id, true

    create_table :communication_website_page_localizations, id: :uuid do |t|
      t.string :breadcrumb_title
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.boolean :header_cta
      t.string :header_cta_label
      t.string :header_cta_url
      t.string :header_text
      t.string :meta_description
      t.string :migration_identifier
      t.boolean :published
      t.datetime :published_at
      t.string :slug
      t.text :summary
      t.text :text
      t.string :title

      t.references :about, foreign_key: { to_table: :communication_website_pages }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end

    Communication::Website::Page.find_each do |page|
      puts "Migration page #{page.id}"

      about_id = page.original_id || page.id

      l10n = Communication::Website::Page::Localization.create(
        breadcrumb_title: page.breadcrumb_title,
        featured_image_alt: page.featured_image_alt,
        featured_image_credit: page.featured_image_credit,
        header_cta: page.header_cta,
        header_cta_label: page.header_cta_label,
        header_cta_url: page.header_cta_url,
        header_text: page.header_text,
        meta_description: page.meta_description,
        migration_identifier: page.migration_identifier,
        published: page.published,
        published_at: page.published_at,
        slug: page.slug,
        summary: page.summary,
        text: page.text,
        title: page.title,
        about_id: about_id,
        language_id: page.language_id,
        communication_website_id: page.communication_website_id,
        university_id: page.university_id,
        created_at: page.created_at
      )

      page.translate_contents!(l10n)
      page.translate_attachment(l10n, :featured_image)
      page.translate_other_attachments(l10n)

      page.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n
        new_permalink.save
      end

      l10n.save
    end
  end

  def down
    drop_table :communication_website_page_localizations
  end
end
