module Communication::Website::WithRealmUniversity
  extend ActiveSupport::Concern

  def blocks_from_university
    Communication::Block.where(about: university_person_localizations).or(
      Communication::Block.where(about: university_organization_localizations)
    )
  end

  def university_person_localizations
    University::Person::Localization.where(
      about: connected_people,
      language: active_languages
    )
  end

  def university_organization_localizations
    University::Organization::Localization.where(
      about: connected_organizations,
      language: active_languages
    )
  end

  def has_organizations?
    connected_organizations.any?
  end

  def has_persons?
    connected_people.any?
  end

end