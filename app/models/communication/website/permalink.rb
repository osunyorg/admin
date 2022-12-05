# == Schema Information
#
# Table name: communication_website_previous_links
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null
#  link          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null
#  university_id :uuid             not null, indexed
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_previous_links_on_university_id  (university_id)
#  index_communication_website_previous_links_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_e9646cce64  (university_id => universities.id)
#  fk_rails_f389ba7d45  (website_id => communication_websites.id)
#
class Communication::Website::Permalink < ApplicationRecord
  include Sanitizable
  include WithUniversity

  belongs_to :university
  belongs_to :website, class_name: "Communication::Website"
  belongs_to :about, polymorphic: true

  before_validation :set_university, on: :create

  private

  def set_university
    self.university_id = website.university_id
  end
end
