# == Schema Information
#
# Table name: education_diplomas
#
#  id                :uuid             not null, primary key
#  description_short :text
#  duration          :text
#  ects              :integer
#  level             :integer          default("not_applicable")
#  name              :string
#  short_name        :string
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  university_id     :uuid             not null, indexed
#
# Indexes
#
#  index_education_diplomas_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_6cb2e9fa90  (university_id => universities.id)
#
require "test_helper"

class Education::DiplomaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
