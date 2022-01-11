# == Schema Information
#
# Table name: education_program_teachers
#
#  id          :uuid             not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :uuid             not null
#  program_id  :uuid             not null
#
# Indexes
#
#  index_education_program_teachers_on_person_id   (person_id)
#  index_education_program_teachers_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => university_people.id)
#  fk_rails_...  (program_id => education_programs.id)
#
class Education::Program::Teacher < ApplicationRecord
  belongs_to :program, class_name: 'Education::Program'
  belongs_to :person, class_name: 'University::Person'

  validates :person_id, uniqueness: { scope: :program_id }

  scope :ordered, -> { joins(:person).order('university_people.last_name, university_people.first_name') }

  after_commit :sync_program

  def to_s
    person.to_s
  end

  protected

  def sync_program
    program.sync_with_git
  end
end
