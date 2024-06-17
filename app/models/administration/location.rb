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
#  language_id           :uuid             not null, indexed
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
  include Contentful
  include Permalinkable
  include Sanitizable
  include Sluggable
  include Translatable
  include WebsitesLinkable
  include WithBlobs
  include WithCountry
  include WithFeaturedImage
  include WithGitFiles
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

  scope :ordered, -> { order(:name) }

  validates :name, :address, :city, :zipcode, :country, presence: true

  before_validation :ensure_programs_are_in_correct_language

  def to_s
    "#{name}"
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}locations/#{slug}/_index.html" if for_website?(website)
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies +
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

  private

  def ensure_programs_are_in_correct_language
    correct_program_ids = []
    programs.each do |program|
      if program.language_id == language_id
        program_in_correct_language = program
      else
        program_in_correct_language = program.find_or_translate!(language)
      end
      correct_program_ids << program_in_correct_language.id
    end
    self.program_ids = correct_program_ids
  end
end
