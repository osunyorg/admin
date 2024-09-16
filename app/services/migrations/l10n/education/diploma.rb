class Migrations::L10n::Education::Diploma < Migrations::L10n::Base
  def self.execute
    Education::Diploma.where(self.constraint).find_each do |object|
      about_id = object.original_id || object.id
      next if Education::Diploma::Localization.where(
        about_id: about_id,
        language_id: object.language_id
      ).exists?

      l10n = Education::Diploma::Localization.create(
        duration: object.duration,
        name: object.name,
        short_name: object.short_name,
        slug: object.slug,
        summary: object.summary,
        about_id: about_id,
        language_id: object.language_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      object.translate_contents!(l10n)

      duplicate_permalinks(object, l10n)
      reconnect_git_files(object, l10n)

      l10n.save
    end
  end
end