# == Schema Information
#
# Table name: university_apps
#
#  id            :uuid             not null, primary key
#  name          :string
#  token         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_apps_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2d07655e23  (university_id => universities.id)
#
require "test_helper"

class University::ApplicationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
