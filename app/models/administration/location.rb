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
  include WithBlobs
  include WithCountry
  include Websitable
  include WithGitFiles
  include WithGeolocation
  include WithUniversity

  scope :ordered, -> { order(:name) }

  validates :name, :address, :city, :zipcode, :country, presence: true

  def to_s
    "#{name}"
  end
end
