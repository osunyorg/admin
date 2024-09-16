class Migrations::L10n::Research::Journal::Paper::Kind < Migrations::L10n::Base
  def self.execute
    Research::Journal::Paper::Kind.find_each do |object|
      # Les types ne sont pas localisés du tout
      about_id = object.id

      l10n = Research::Journal::Paper::Kind::Localization.create(
        slug: object.slug,
        title: object.title,

        about_id: about_id,
        language_id: object.journal.language_id,
        university_id: object.university_id,
        created_at: object.created_at
      )
    end
  end
end