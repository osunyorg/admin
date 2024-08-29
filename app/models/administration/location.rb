# == Schema Information
#
# Table name: administration_locations
#
#  id                    :uuid             not null, primary key
#  address               :string
#  address_additional    :string
#  address_name          :string
#  city                  :string
#  country               :string
#  featured_image_alt    :text
#  featured_image_credit :text
#  latitude              :float
#  longitude             :float
#  name                  :string
#  phone                 :string
#  slug                  :string
#  summary               :text
#  url                   :string
#  zipcode               :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  language_id           :uuid             indexed
#  original_id           :uuid             indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  index_administration_locations_on_language_id    (language_id)
#  index_administration_locations_on_original_id    (original_id)
#  index_administration_locations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2ba052f7a2  (original_id => administration_locations.id)
#  fk_rails_5951e4a1ea  (language_id => languages.id)
#  fk_rails_bfeca0e4b1  (university_id => universities.id)
#
class Administration::Location < ApplicationRecord
  include AsIndirectObject
  include Contentful # TODO L10N : To remove
  include Sanitizable
  include Localizable
  include WebsitesLinkable
  include WithBlobs # TODO L10N : To remove
  include WithCountry
  include WithFeaturedImage # TODO L10N : To remove
  include WithGitFiles
  include WithGeolocation
  include WithUniversity

  # TODO L10N : remove after migrations
  has_many  :permalinks,
            class_name: "Communication::Website::Permalink",
            as: :about,
            dependent: :destroy

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

  scope :ordered, -> { order(:name) }

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
