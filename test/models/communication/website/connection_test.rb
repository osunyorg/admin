# == Schema Information
#
# Table name: communication_website_connections
#
#  id            :uuid             not null, primary key
#  object_type   :string           not null, indexed => [object_id]
#  source_type   :string           indexed => [source_id]
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  object_id     :uuid             not null, indexed => [object_type]
#  source_id     :uuid             indexed => [source_type]
#  university_id :uuid             not null, indexed
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_connections_on_object         (object_type,object_id)
#  index_communication_website_connections_on_source         (source_type,source_id)
#  index_communication_website_connections_on_university_id  (university_id)
#  index_communication_website_connections_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_728034883b  (website_id => communication_websites.id)
#  fk_rails_bd1ac8383b  (university_id => universities.id)
#
require "test_helper"

class Communication::Website::ConnectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
