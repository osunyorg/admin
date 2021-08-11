# == Schema Information
#
# Table name: features_education_programs
#
#  id            :uuid             not null, primary key
#  accessibility :text
#  capacity      :integer
#  contacts      :text
#  continuing    :boolean
#  duration      :text
#  ects          :integer
#  evaluation    :text
#  level         :integer
#  name          :string
#  objectives    :text
#  pedagogy      :text
#  prerequisites :text
#  pricing       :text
#  registration  :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#
# Indexes
#
#  index_features_education_programs_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
class Features::Education::Program < ApplicationRecord
  belongs_to :university

  enum level: {
    bachelor: 300,
    master: 500,
    doctor: 800
  }

  validates_presence_of :name

  def to_s
    "#{name}"
  end
end
