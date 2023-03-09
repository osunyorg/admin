# == Schema Information
#
# Table name: communication_extranet_post_categories
#
#  id            :uuid             not null, primary key
#  name          :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  extranet_id   :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranet_post_categories_on_extranet_id    (extranet_id)
#  index_communication_extranet_post_categories_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_aad7b8db63  (university_id => universities.id)
#  fk_rails_e53c2a25fc  (extranet_id => communication_extranets.id)
#
require "test_helper"

class Communication::Extranet::Post::CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
