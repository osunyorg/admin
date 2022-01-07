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
require "test_helper"

class Education::School::AdministratorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
