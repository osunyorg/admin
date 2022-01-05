# == Schema Information
#
# Table name: education_program_members
#
#  id         :uuid             not null, primary key
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  member_id  :uuid             not null
#  program_id :uuid             not null
#
# Indexes
#
#  index_education_program_members_on_member_id   (member_id)
#  index_education_program_members_on_program_id  (program_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => university_people.id)
#  fk_rails_...  (program_id => education_programs.id)
#
require "test_helper"

class Education::Program::MemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
