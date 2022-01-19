# == Schema Information
#
# Table name: research_laboratories
#
#  id            :uuid             not null, primary key
#  address       :string
#  city          :string
#  country       :string
#  name          :string
#  zipcode       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#
# Indexes
#
#  index_research_laboratories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
require "test_helper"

class Research::LaboratoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
