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
#  zipcode       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#
# Indexes
#
#  index_education_schools_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
class Education::School < ApplicationRecord
  belongs_to :university
  has_one :website, class_name: 'Communication::Website', foreign_key: :about

  def to_s
    "#{name}"
  end
end
