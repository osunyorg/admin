# == Schema Information
#
# Table name: communication_extranet_localizations
#
#  id                         :uuid             not null, primary key
#  cookies_policy             :text
#  home_sentence              :text
#  invitation_message_subject :string           default("")
#  invitation_message_text    :text             default("")
#  name                       :string
#  privacy_policy             :text
#  published                  :boolean          default(FALSE)
#  published_at               :datetime
#  registration_contact       :string
#  sso_button_label           :string
#  terms                      :text
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  about_id                   :uuid             indexed
#  language_id                :uuid             indexed
#  university_id              :uuid             indexed
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
  include Sanitizable
  include WithUniversity

  has_summernote :home_sentence
  has_summernote :terms
  has_summernote :privacy_policy
  has_summernote :cookies_policy

  has_one_attached_deletable :logo
  has_one_attached_deletable :favicon do |attachable|
    attachable.variant :thumb, resize_to_limit: [228, 228]
  end

  before_validation :set_default_invitation_message

  validates :name, presence: true
  validates :logo, size: { less_than: 1.megabytes }
  validates :favicon, size: { less_than: 1.megabytes }
  validate :prevent_unpublishing_default_language

  def to_s
    "#{name}"
  end

  protected

  def prevent_unpublishing_default_language
    return unless about.default_language_id == language_id
    return if published?
    errors.add(:published, :cannot_unpublished_default)
  end

  def set_default_invitation_message
    self.invitation_message_subject = I18n.t('mailers.extranet.invitation_message.subject') if self.invitation_message_subject.blank?
    self.invitation_message_text = I18n.t('mailers.extranet.invitation_message.text') if self.invitation_message_text.blank?
  end

end
