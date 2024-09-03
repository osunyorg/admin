class Migrations::L10n::Education::School < Migrations::L10n::Base
  def self.execute
    Education::School.find_each do |object|
      about_id = object.original_id || object.id

      next if Education::School::Localization.where(
        about_id: about_id,
        language_id: object.language_id
      ).exists?

      l10n = Education::School::Localization.create(
        name: object.name,
        published: true,
        published_at: object.created_at,
        url: object.url,
        about_id: about_id,
        language_id: object.language_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      object.translate_attachment(l10n, :logo)

      duplicate_permalinks(object, l10n)

      l10n.save
    end
  end
end