class CreateCommunicationAgendaEventLocalizations < ActiveRecord::Migration[7.1]
  def up
    change_column_null :communication_website_agenda_events, :language_id, true

    create_table :communication_website_agenda_event_localizations, id: :uuid do |t|
      t.jsonb :add_to_calendar_urls
      t.string :featured_image_alt
      t.text :featured_image_credit
      t.string :meta_description
      t.string :migration_identifier
      t.boolean :published, default: false
      t.datetime :published_at
      t.string :slug
      t.string :subtitle
      t.text :summary
      t.text :text # No text yet
      t.string :title

      t.references :about, foreign_key: { to_table: :communication_website_agenda_events }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :communication_website, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end

    Communication::Website::Agenda::Event.find_each do |event|
      puts "Migration event #{event.id}"

      about_id = event.original_id || event.id

      l10n = Communication::Website::Agenda::Event::Localization.create(
        add_to_calendar_urls: event.add_to_calendar_urls,
        featured_image_alt: event.featured_image_alt,
        featured_image_credit: event.featured_image_credit,
        meta_description: event.meta_description,
        migration_identifier: event.migration_identifier,
        published: event.published,
        published_at: event.updated_at, # No published_at yet
        slug: event.slug,
        subtitle: event.subtitle,
        summary: event.summary,
        title: event.title,
        about_id: about_id,

        language_id: event.language_id,
        communication_website_id: event.communication_website_id,
        university_id: event.university_id,
        created_at: event.created_at
      )

      event.translate_contents!(l10n)
      event.translate_attachment(l10n, :featured_image)
      event.translate_other_attachments(l10n)

      event.permalinks.each do |permalink|
        new_permalink = permalink.dup
        new_permalink.about = l10n
        new_permalink.save
      end

      l10n.save
    end
  end

  def down
    drop_table :communication_website_agenda_event_localizations
  end
end
