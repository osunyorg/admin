class Migrations::L10n::Administration::Location < Migrations::L10n::Base
  def self.execute
    Administration::Location.find_each do |object|
      about_id = object.original_id || object.id
      next if Administration::Location::Localization.where(
        about_id: about_id,
        language_id: object.language_id
      ).exists?

      l10n = Administration::Location::Localization.create(
        address_additional: object.address_additional,
        address_name: object.address_name,
        featured_image_alt: object.featured_image_alt,
        featured_image_credit: object.featured_image_credit,
        name: object.name,
        slug: object.slug,
        summary: object.summary,
        url: object.url,
        about_id: about_id,
        language_id: object.language_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      object.translate_contents!(l10n)
      object.translate_attachment(l10n, :featured_image)

      duplicate_permalinks(object, l10n)

      l10n.save
    end
  end
end