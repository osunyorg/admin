# == Schema Information
#
# Table name: universities
#
#  id         :uuid             not null, primary key
#  address    :string
#  city       :string
#  country    :string
#  identifier :string
#  name       :string
#  private    :boolean
#  zipcode    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class University < ApplicationRecord
  validates_presence_of :name
  scope :ordered, -> { order(:name) }

  include WithIdentifier
  include WithUsers
  include WithFeatures
  include WithResearch

  def to_s
    "#{name}"
  end
end
