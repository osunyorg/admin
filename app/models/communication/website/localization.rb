# == Schema Information
#
# Table name: communication_website_localizations
#
#  id                       :uuid             not null, primary key
#  name                     :string
#  social_email             :string
#  social_facebook          :string
#  social_github            :string
#  social_instagram         :string
#  social_linkedin          :string
#  social_mastodon          :string
#  social_peertube          :string
#  social_tiktok            :string
#  social_vimeo             :string
#  social_x                 :string
#  social_youtube           :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_ed4630e334                  (communication_website_id)
#  index_communication_website_localizations_on_language_id    (language_id)
#  index_communication_website_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2b920b0a3a  (language_id => languages.id)
#  fk_rails_431797c26c  (communication_website_id => communication_websites.id)
#  fk_rails_fc42676b8b  (university_id => universities.id)
#
class Communication::Website::Localization < ApplicationRecord
  include AsDirectObject
  include Sanitizable
  include WithUniversity

  belongs_to :language

  validates :language_id, uniqueness: { scope: :communication_website_id }

  before_validation :set_university_id, on: :create

  # Localization is not directly exportable to git
  # Whereas the languages config in the dependencies is exportable to git
  def exportable_to_git?
    false
  end

  def dependencies
    [website.config_default_languages]
  end

  def computed_name
    name.present? ? "#{name}" : website.to_s
  end

  private

  def set_university_id
    self.university_id = website.university_id
  end
end
