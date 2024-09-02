class Migrations::L10n::Communication::Website::Agenda::Event < Migrations::L10n::Base
  def self.execute
    Communication::Website::Agenda::Event.find_each do |event|
      puts "Migration event #{event.id}"

      about_id = event.original_id || event.id
      next if Communication::Website::Agenda::Event::Localization.where(
        about_id: about_id,
        language_id: event.language_id
      ).exists?

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

      duplicate_permalinks(event, l10n)

      l10n.save
    end
  end
end