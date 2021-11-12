# == Schema Information
#
# Table name: education_programs
#
#  id            :uuid             not null, primary key
#  capacity      :integer
#  continuing    :boolean
#  ects          :integer
#  level         :integer
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#
# Indexes
#
#  index_education_programs_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
class Education::Program < ApplicationRecord
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
