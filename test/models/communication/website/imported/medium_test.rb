# == Schema Information
#
# Table name: communication_website_imported_media
#
#  id            :uuid             not null, primary key
#  data          :jsonb
#  file_url      :text
#  filename      :string
#  identifier    :string
#  mime_type     :string
#  created_at    :datetime
#  updated_at    :datetime
#  medium_id     :uuid
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_imported_media_on_medium_id      (medium_id)
#  index_communication_website_imported_media_on_university_id  (university_id)
#  index_communication_website_imported_media_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (medium_id => communication_website_media.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_website_imported_websites.id)
#
require "test_helper"

class Communication::Website::Imported::MediumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
