# == Schema Information
#
# Table name: communication_website_alert_localizations
#
#  id                       :uuid             not null, primary key
#  cta                      :boolean          default(FALSE)
#  cta_label                :string
#  cta_url                  :string
#  description              :text
#  published                :boolean          default(FALSE)
#  published_at             :datetime
#  slug                     :string
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             not null, uniquely indexed => [language_id], indexed
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, uniquely indexed => [about_id], indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_about_id_language_id_d42c296af1                          (about_id,language_id) UNIQUE
#  idx_on_communication_website_id_419e31417f                      (communication_website_id)
#  idx_on_university_id_a434d41212                                 (university_id)
#  index_communication_website_alert_localizations_on_about_id     (about_id)
#  index_communication_website_alert_localizations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_2cf51cea51  (communication_website_id => communication_websites.id)
#  fk_rails_3474adea32  (university_id => universities.id)
#  fk_rails_5dcabe7842  (about_id => communication_website_alerts.id)
#  fk_rails_ec345cee0b  (language_id => languages.id)
#
class Communication::Website::Alert::Localization < ApplicationRecord
  acts_as_paranoid

  include AsLocalization
  include HasGitFiles
  include Initials
  include Permalinkable # slug_unavailable method overwrite in this file
  include Publishable
  include Sanitizable
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  alias :alert :about

  validates :title, presence: true

  before_validation :set_communication_website_id, on: :create

  def git_path(website)
    "data/alerts/#{language.iso_code}/#{slug}.yml"
  end

  def should_sync_to?(website)
    website.id == communication_website_id &&
    website.active_language_ids.include?(language_id) &&
    published?
  end

  def template_static
    "admin/communication/websites/alerts/static"
  end

  def cta_url_external?(website)
    return false if cta_url.blank?
    !cta_url_internal?(website)
  end

  def cta_url_internal?(website)
    return false if cta_url.blank?
    cta_url.start_with?('/') || cta_url.start_with?(website.url)
  end

  def to_s
    "#{title}"
  end

  protected

  def slug_unavailable?(slug)
    self.class.unscoped
              .left_joins(:about)
              .where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end
end
