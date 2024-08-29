class Migrations::L10n::University::Person::Involvement < Migrations::L10n::Base
  def self.execute
    migrate_localizations
  end

  def self.migrate_localizations
    University::Person::Involvement.find_each do |involvement|
      language_id = involvement.person.language_id
      l10n = University::Person::Involvement::Localization.create(
        description: involvement.description,
        about_id: involvement.id,
        language_id: language_id,
        university_id: involvement.university_id,
        created_at: involvement.created_at
      )
    end
  end
end
