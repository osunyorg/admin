# == Schema Information
#
# Table name: communication_website_localizations
#
#  id               :uuid             not null, primary key
#  name             :string
#  social_email     :string
#  social_facebook  :string
#  social_github    :string
#  social_instagram :string
#  social_linkedin  :string
#  social_mastodon  :string
#  social_peertube  :string
#  social_tiktok    :string
#  social_vimeo     :string
#  social_x         :string
#  social_youtube   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  about_id         :uuid             not null, indexed
#  language_id      :uuid             not null, indexed
#  university_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_localizations_on_about_id       (about_id)
#  index_communication_website_localizations_on_language_id    (language_id)
#  index_communication_website_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2b920b0a3a  (language_id => languages.id)
#  fk_rails_431797c26c  (about_id => communication_websites.id)
#  fk_rails_fc42676b8b  (university_id => universities.id)
#
class Communication::Website::Localization < ApplicationRecord
  include AsLocalization
  include WithUniversity

  # Localization is not directly exportable to git
  # Whereas the languages config in the dependencies is exportable to git
  def exportable_to_git?
    false
  end

  def dependencies
    # 1 single file for all the languages
    [website.config_default_languages]
  end

  def to_s
    name
  end
end
