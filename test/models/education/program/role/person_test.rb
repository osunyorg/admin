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
require "test_helper"

class Education::Program::Role::PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
