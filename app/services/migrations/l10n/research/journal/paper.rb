class Migrations::L10n::Research::Journal::Paper < Migrations::L10n::Base
  def self.execute
    Research::Journal::Paper.find_each do |object|
      # Les papiers ne sont pas localisés du tout
      about_id = object.id

      l10n = Research::Journal::Paper::Localization.create(
        abstract: object.abstract,
        authors_list: object.authors_list,
        keywords: object.keywords,
        meta_description: object.meta_description,
        published: object.published,
        published_at: object.published_at,
        slug: object.slug,
        summary: object.summary,
        title: object.title,

        about_id: about_id,
        language_id: object.journal.language_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      object.translate_contents!(l10n)
      object.translate_attachment(l10n, :pdf)
      duplicate_permalinks(object, l10n)
      reconnect_git_files(object, l10n)

      l10n.save
    end
  end
end