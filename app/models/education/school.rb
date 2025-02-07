# == Schema Information
#
# Table name: education_schools
#
#  id            :uuid             not null, primary key
#  address       :string
#  city          :string
#  country       :string
#  latitude      :float
#  longitude     :float
#  phone         :string
#  zipcode       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_education_schools_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_e01b37a3ad  (university_id => universities.id)
#
class Education::School < ApplicationRecord
  include AsIndirectObject
  include Filterable
  include Sanitizable
  include Searchable
  include Localizable
  include LocalizableOrderByNameScope
  include WebsitesLinkable
  include WithCountry
  include WithLocations
  include WithPrograms # must come before WithAlumni and WithTeam
  include WithAlumni
  include WithTeam
  include WithUniversity

  # 'websites' might override the same method defined in WithWebsites, so we use the full name
  has_many    :communication_websites,
              class_name: 'Communication::Website',
              as: :about,
              dependent: :nullify
  # Did not specify the dependent option, as it is not clear if the extranet should be destroyed when the school is.
  # Should be checked manually.
  has_many    :communication_extranets,
              class_name: 'Communication::Extranet',
              as: :about

  validates :address, :city, :zipcode, :country, presence: true

  scope :for_search_term, -> (term, language) {
     joins(:localizations)
      .where(education_school_localizations: { language_id: language.id })
      .where("
        unaccent(education_schools.address) ILIKE unaccent(:term) OR
        unaccent(education_schools.city) ILIKE unaccent(:term) OR
        unaccent(education_schools.country) ILIKE unaccent(:term) OR
        unaccent(education_school_localizations.name) ILIKE unaccent(:term) OR
        unaccent(education_schools.phone) ILIKE unaccent(:term) OR
        unaccent(education_schools.zipcode) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_program, -> (program_id, language = nil) {
    joins(:programs).where(education_programs: { id: program_id })
  }

  def dependencies
    localizations +
    programs +
    # As diplomas are here through programs, and diploma being a program's dependency, it this necessary?
    diplomas +
    locations +
    administrators.map(&:administrator_facets) +
    researchers.map(&:researcher_facets)
  end

  #####################
  # WebsitesLinkable methods
  #####################

  def has_research_papers?
    false
  end

  def has_research_volumes?
    false
  end

end
