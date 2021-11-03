# == Schema Information
#
# Table name: communication_website_menus
#
#  id            :uuid             not null, primary key
#  identifier    :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null
#  website_id    :uuid             not null
#
# Indexes
#
#  index_communication_website_menus_on_university_id  (university_id)
#  index_communication_website_menus_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (website_id => communication_websites.id)
#
class Communication::Website::Menu < ApplicationRecord
  belongs_to :university
  belongs_to :website, class_name: 'Communication::Website'
end
