class Migrations::L10n::Research::Journal::Volume < Migrations::L10n::Base
  def self.execute
    Research::Journal::Volume.find_each do |object|
      # Les volumes ne sont pas localisés du tout
      about_id = object.id

      l10n = Research::Journal::Volume::Localization.create(
        featured_image_alt: object.featured_image_alt,
        featured_image_credit: object.featured_image_credit,
        keywords: object.keywords,
        meta_description: object.meta_description,
        published: object.published,
        published_at: object.published_at,
        slug: object.slug,
        summary: object.summary,
        text: object.text,
        title: object.title,

        about_id: about_id,
        language_id: object.journal.language_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      l10n.save
    end
  end
end