# == Schema Information
#
# Table name: education_cohorts
#
#  id               :uuid             not null, primary key
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  academic_year_id :uuid             not null, indexed
#  program_id       :uuid             not null, indexed
#  school_id        :uuid             not null, indexed
#  university_id    :uuid             not null, indexed
#
# Indexes
#
#  index_education_cohorts_on_academic_year_id  (academic_year_id)
#  index_education_cohorts_on_program_id        (program_id)
#  index_education_cohorts_on_school_id         (school_id)
#  index_education_cohorts_on_university_id     (university_id)
#
# Foreign Keys
#
#  fk_rails_0f4a4f43d9  (university_id => universities.id)
#  fk_rails_72528c3d76  (program_id => education_programs.id)
#  fk_rails_8545767e2d  (school_id => education_schools.id)
#  fk_rails_c2d725cabd  (academic_year_id => education_academic_years.id)
#
require "test_helper"

class Education::CohortTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
