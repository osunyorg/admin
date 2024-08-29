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
#  name          :string
#  phone         :string
#  url           :string
#  zipcode       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  language_id   :uuid             indexed
#  original_id   :uuid             indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_education_schools_on_language_id    (language_id)
#  index_education_schools_on_original_id    (original_id)
#  index_education_schools_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_84e48509e8  (language_id => languages.id)
#  fk_rails_cba5631cc9  (original_id => education_schools.id)
#  fk_rails_e01b37a3ad  (university_id => universities.id)
#
class Education::School < ApplicationRecord
  include AsIndirectObject
  include Sanitizable
  include Localizable
  include WebsitesLinkable
  include WithBlobs # TODO L10N : To remove
  include WithCountry
  include WithGitFiles
  include WithLocations
  include WithPrograms # must come before WithAlumni and WithTeam
  include WithAlumni
  include WithTeam
  include WithUniversity

  # TODO L10N : remove after migrations
  has_many  :permalinks,
            class_name: "Communication::Website::Permalink",
            as: :about,
            dependent: :destroy

  # 'websites' might override the same method defined in WithWebsites, so we use the full name
  has_many    :communication_websites,
              class_name: 'Communication::Website',
              as: :about,
              dependent: :nullify

  has_one_attached_deletable :logo # TODO L10N : To remove

  validates :address, :city, :zipcode, :country, presence: true

  scope :ordered, -> { order(:name) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(education_schools.address) ILIKE unaccent(:term) OR
      unaccent(education_schools.city) ILIKE unaccent(:term) OR
      unaccent(education_schools.country) ILIKE unaccent(:term) OR
      unaccent(education_schools.name) ILIKE unaccent(:term) OR
      unaccent(education_schools.phone) ILIKE unaccent(:term) OR
      unaccent(education_schools.zipcode) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_program, -> (program_id) {
    joins(:programs).where(education_programs: { id: program_id })
  }

  def dependencies
    programs +
    # As diplomas are here through programs, and diploma being a program's dependency, it this necessary?
    diplomas +
    locations +
    administrators.map(&:administrator) +
    researchers.map(&:researcher)
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
