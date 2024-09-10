class Migrations::L10n::Research::Journal < Migrations::L10n::Base
  def self.execute
    migrate_journals
    Volume.execute
    Paper.execute
    Paper::Kind.execute
  end

  def self.migrate_journals
    Research::Journal.find_each do |object|
      # Les journaux ne sont pas localisés du tout
      # ils ont juste une info de langue (pas d'original_id)
      about_id = object.id

      l10n = Research::Journal::Localization.create(
        issn: object.issn,
        meta_description: object.meta_description,
        summary: object.summary,
        title: object.title,
        about_id: about_id,
        language_id: object.language_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      duplicate_permalinks(object, l10n)
      reconnect_git_files(object, l10n)
    end
  end
end