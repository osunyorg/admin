class Migrations::L10n::Research::Thesis < Migrations::L10n::Base
  def self.execute
    Research::Thesis.find_each do |object|
      # Les thèses ne sont pas localisés du tout
      about_id = object.id

      l10n = Research::Thesis::Localization.create(
        abstract: object.abstract,
        title: object.title,
        about_id: about_id,
        language_id: object.university.default_language_id,
        university_id: object.university_id,
        created_at: object.created_at
      )

      l10n.save
    end
  end
end