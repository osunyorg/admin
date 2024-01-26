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
#  name          :string
#  phone         :string
#  slug          :string
#  summary       :text
#  url           :string
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
  include Contentful
  include Sluggable
  include WebsitesLinkable
  include WithBlobs
  include WithCountry
  include WithGitFiles
  include WithGeolocation
  include WithPermalink
  include WithUniversity

  has_and_belongs_to_many :schools,
                          class_name: 'Education::School',
                          foreign_key: :education_school_id,
                          association_foreign_key: :administration_location_id
  has_and_belongs_to_many :programs,
                          class_name: 'Education::Program',
                          foreign_key: :education_program_id,
                          association_foreign_key: :administration_location_id


  scope :ordered, -> { order(:name) }

  validates :name, :address, :city, :zipcode, :country, presence: true

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
end
