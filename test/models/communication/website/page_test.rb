# == Schema Information
#
# Table name: communication_website_pages
#
#  id                       :uuid             not null, primary key
#  about_type               :string
#  description              :text
#  path                     :text
#  position                 :integer          default(0), not null
#  published_at             :datetime
#  slug                     :string
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid
#  communication_website_id :uuid             not null
#  parent_id                :uuid
#  university_id            :uuid             not null
#
# Indexes
#
#  index_communication_website_pages_on_about                     (about_type,about_id)
#  index_communication_website_pages_on_communication_website_id  (communication_website_id)
#  index_communication_website_pages_on_parent_id                 (parent_id)
#  index_communication_website_pages_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (communication_website_id => communication_websites.id)
#  fk_rails_...  (parent_id => communication_website_pages.id)
#  fk_rails_...  (university_id => universities.id)
#
require "test_helper"

class Communication::Website::PageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
