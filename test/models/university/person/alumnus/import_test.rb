# == Schema Information
#
# Table name: university_person_alumnus_imports
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#  user_id       :uuid             not null, indexed
#
# Indexes
#
#  index_university_person_alumnus_imports_on_university_id  (university_id)
#  index_university_person_alumnus_imports_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_3ff74ac195  (user_id => users.id)
#  fk_rails_d14eb003f9  (university_id => universities.id)
#
require "test_helper"

class University::Person::Alumnus::ImportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
