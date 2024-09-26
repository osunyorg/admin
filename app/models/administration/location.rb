# == Schema Information
#
# Table name: administration_locations
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
#  index_administration_locations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_bfeca0e4b1  (university_id => universities.id)
#
class Administration::Location < ApplicationRecord
  include AsIndirectObject
  include Sanitizable
  include Localizable
  include LocalizableOrderByNameScope
  include WebsitesLinkable
  include WithCountry
  include WithGeolocation
  include WithUniversity

  has_and_belongs_to_many :schools,
                          class_name: 'Education::School',
                          foreign_key: :administration_location_id,
                          association_foreign_key: :education_school_id
                          alias_method :education_schools, :schools
  has_and_belongs_to_many :programs,
                          class_name: 'Education::Program',
                          foreign_key: :administration_location_id,
                          association_foreign_key: :education_program_id
                          alias_method :education_programs, :programs
  has_many                :diplomas,
                          -> { distinct },
                          through: :programs,
                          source: :diploma
                          alias_method :education_diplomas, :diplomas

  validates :address, :city, :zipcode, :country, presence: true

  def dependencies
    active_storage_blobs +
    programs +
    schools
  end

  def references
    []
  end

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  # WebsitesLinkable

  def has_administrators?
    # TODO les administrateurs du site
    false
  end

  def has_researchers?
    # TODO les chercheurs du site
    false
  end

  def has_teachers?
    # TODO les enseignants du site
    false
  end

  def has_education_programs?
    programs.any?
  end

  def has_education_diplomas?
    diplomas.any?
  end

  def has_research_papers?
    false
  end

  def has_research_volumes?
    false
  end

  def has_administration_locations?
    # Un site (location) n'a pas de site (location) dépendant
    false
  end
end
