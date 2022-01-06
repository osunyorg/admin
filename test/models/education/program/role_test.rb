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
require "test_helper"

class Education::Program::RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
