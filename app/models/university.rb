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
#  integer_id :bigint
#
class University < ApplicationRecord
  validates_presence_of :name
  scope :ordered, -> { order(:name) }

  include WithIdentifier
  include WithFeatureEducation

  def to_s
    "#{name}"
  end
end
