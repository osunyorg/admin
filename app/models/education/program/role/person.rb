# == Schema Information
#
# Table name: education_program_role_people
#
#  id         :uuid             not null, primary key
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :uuid             not null
#  role_id    :uuid             not null
#
# Indexes
#
#  index_education_program_role_people_on_person_id  (person_id)
#  index_education_program_role_people_on_role_id    (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => university_people.id)
#  fk_rails_...  (role_id => education_program_roles.id)
#
class Education::Program::Role::Person < ApplicationRecord
  include WithPosition

  belongs_to :person, class_name: 'University::Person'
  belongs_to :role, class_name: 'Education::Program::Role'
  delegate :program, to: :role

  after_commit :sync_program

  def to_s
    person.to_s
  end

  protected

  def last_ordered_element
    role.people.ordered.last
  end

  def sync_program
    program.sync_with_git
  end
end
