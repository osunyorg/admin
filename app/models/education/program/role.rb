# == Schema Information
#
# Table name: education_program_roles
#
#  id            :uuid             not null, primary key
#  position      :integer
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  program_id    :uuid             not null
#  university_id :uuid             not null
#
# Indexes
#
#  index_education_program_roles_on_program_id     (program_id)
#  index_education_program_roles_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (program_id => education_programs.id)
#  fk_rails_...  (university_id => universities.id)
#
class Education::Program::Role < ApplicationRecord
  include WithPosition

  belongs_to :university
  belongs_to :program, class_name: 'Education::Program'
  has_many :people, class_name: 'Education::Program::Role::Person', dependent: :destroy
  has_many :university_people, through: :people, source: :person

  after_commit :sync_program

  def to_s
    "#{title}"
  end

  def sync_program
    program.sync_with_git
  end

  protected

  def last_ordered_element
    program.roles.ordered.last
  end
end
