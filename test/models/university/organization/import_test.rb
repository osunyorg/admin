# == Schema Information
#
# Table name: university_organization_imports
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#  user_id       :uuid             not null, indexed
#
# Indexes
#
#  index_university_organization_imports_on_university_id  (university_id)
#  index_university_organization_imports_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_31152af0cd  (university_id => universities.id)
#  fk_rails_da057ff44d  (user_id => users.id)
#
require "test_helper"

class University::Organization::ImportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
