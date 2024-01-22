# == Schema Information
#
# Table name: communication_website_localizations
#
#  id                       :uuid             not null, primary key
#  email                    :string
#  facebook                 :string
#  github                   :string
#  instagram                :string
#  linkedin                 :string
#  mastodon                 :string
#  name                     :string
#  peertube                 :string
#  tiktok                   :string
#  vimeo                    :string
#  x                        :string
#  youtube                  :string
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

  before_validation :set_university_id

  private

  def set_university_id
    self.university_id = communication_website.university_id
  end
end
