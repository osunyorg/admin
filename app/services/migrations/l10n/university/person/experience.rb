class Migrations::L10n::University::Person::Experience < Migrations::L10n::Base
  def self.execute
    University::Person::Experience.find_each do |experience|
      language_id = experience.person.language_id
      next if University::Person::Experience::Localization.where(
        about_id: experience.id,
        language_id: language_id
      ).exists?

      l10n = University::Person::Experience::Localization.create(
        description: experience.description,
        about_id: experience.id,
        language_id: language_id,
        university_id: experience.university_id,
        created_at: experience.created_at
      )
      person_id = experience.person.original_id || experience.person_id
      organization_id = experience.organization.original_id || experience.organization_id
      experience.update_columns(
        person_id: person_id,
        organization_id: organization_id
      )
    end
  end
end
