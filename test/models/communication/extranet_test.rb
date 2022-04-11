# == Schema Information
#
# Table name: communication_extranets
#
#  id            :uuid             not null, primary key
#  about_type    :string           indexed => [about_id]
#  domain        :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed => [about_type]
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranets_on_about          (about_type,about_id)
#  index_communication_extranets_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_c2268c7ebd  (university_id => universities.id)
#
require "test_helper"

class Communication::ExtranetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
