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
require "test_helper"

class Education::Program::TeacherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
