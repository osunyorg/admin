# == Schema Information
#
# Table name: education_school_administrators
#
#  id          :uuid             not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :uuid             not null
#  school_id   :uuid             not null
#
# Indexes
#
#  index_education_school_administrators_on_person_id  (person_id)
#  index_education_school_administrators_on_school_id  (school_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => university_people.id)
#  fk_rails_...  (school_id => education_schools.id)
#
class Education::School::Administrator < ApplicationRecord
  belongs_to :school
  belongs_to :person, class_name: "University::Person"

  validates :person_id, uniqueness: { scope: :school_id }

  after_commit :sync_school

  scope :ordered, -> { joins(:person).order('university_people.last_name, university_people.first_name') }

  def to_s
    person.to_s
  end

  protected

  def sync_school
    school.sync_with_git
  end
end
