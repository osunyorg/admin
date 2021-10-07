# == Schema Information
#
# Table name: communication_website_imported_pages
#
#  id            :uuid             not null, primary key
#  status        :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  page_id       :uuid             not null
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_imported_pages_on_page_id        (page_id)
#  index_communication_website_imported_pages_on_university_id  (university_id)
#  index_communication_website_imported_pages_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (page_id => communication_website_pages.id)
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_website_imported_websites.id)
#
require "test_helper"

class Communication::Website::Imported::PageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
