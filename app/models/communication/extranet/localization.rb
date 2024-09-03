# == Schema Information
#
# Table name: communication_extranet_localizations
#
#  id                   :uuid             not null, primary key
#  cookies_policy       :text
#  home_sentence        :text
#  name                 :string
#  privacy_policy       :text
#  registration_contact :string
#  sso_button_label     :string
#  terms                :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  about_id             :uuid             indexed
#  language_id          :uuid             indexed
#  university_id        :uuid             indexed
#
# Indexes
#
#  index_communication_extranet_localizations_on_about_id       (about_id)
#  index_communication_extranet_localizations_on_language_id    (language_id)
#  index_communication_extranet_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2f5641d59c  (about_id => communication_extranets.id)
#  fk_rails_4f49df5b58  (university_id => universities.id)
#  fk_rails_75081bcff8  (language_id => languages.id)
#
class Communication::Extranet::Localization < ApplicationRecord
  include AsLocalization
  include Initials
  include WithUniversity

  has_summernote :home_sentence
  has_summernote :terms
  has_summernote :privacy_policy
  has_summernote :cookies_policy

  has_one_attached_deletable :logo
  has_one_attached_deletable :favicon do |attachable|
    attachable.variant :thumb, resize_to_limit: [228, 228]
  end

  before_validation :sanitize_fields

  def to_s
    "#{name}"
  end

  protected

  def sanitize_fields
    self.cookies_policy = Osuny::Sanitizer.sanitize(self.cookies_policy, 'text')
    self.name = Osuny::Sanitizer.sanitize(self.name, 'string')
    self.privacy_policy = Osuny::Sanitizer.sanitize(self.privacy_policy, 'text')
    self.registration_contact = Osuny::Sanitizer.sanitize(self.registration_contact, 'string')
    self.terms = Osuny::Sanitizer.sanitize(self.terms, 'text')
  end
end
