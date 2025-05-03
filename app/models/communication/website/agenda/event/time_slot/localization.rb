# == Schema Information
#
# Table name: communication_website_agenda_event_time_slot_localizations
#
#  id                       :uuid             not null, primary key
#  add_to_calendar_urls     :jsonb
#  migration_identifier     :string
#  place                    :string
#  slug                     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             not null, indexed
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_about_id_e52a2e12b0                  (about_id)
#  idx_on_communication_website_id_526f156fed  (communication_website_id)
#  idx_on_language_id_f50f565794               (language_id)
#  idx_on_university_id_4dee92bcc5             (university_id)
#
# Foreign Keys
#
#  fk_rails_058062d234  (university_id => universities.id)
#  fk_rails_641e55dd7e  (about_id => communication_website_agenda_event_time_slots.id)
#  fk_rails_84332c62e4  (language_id => languages.id)
#  fk_rails_ef5c90fa45  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Event::TimeSlot::Localization < ApplicationRecord
  include AddableToCalendar
  include AsDirectObject
  include AsLocalization
  include HasGitFiles
  include Permalinkable
  include WithOpenApi
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  alias :time_slot :about

  delegate :event, to: :about

  delegate :to_s, :title, :subtitle, :summary, :contents_full_text, :previous_permalinks_in_website, to: :event_l10n, allow_nil: true
  delegate :best_bodyclass, :archive?, to: :event

  before_validation :set_communication_website_id, on: :create

  # /content/fr/events/YYYY/MM/DD-hh-mm-slug.html
  def git_path(website)
    return unless website.id == communication_website_id
    git_path_content_prefix(website) + git_path_relative
  end

  # events/YYYY/MM/DD-hh-mm-slug.html
  def git_path_relative
    "events/#{from_day.strftime "%Y/%m"}/#{slug}-#{event_l10n.slug}.html"
  end

  def template_static
    "admin/communication/websites/agenda/events/time_slots/static"
  end

  def from_day
    about.datetime&.to_date
  end

  def from_hour
    about.datetime&.to_time
  end

  def to_day
    about.end_datetime&.to_date
  end

  def to_hour
    about.end_datetime&.to_time
  end

  def time_zone
    event.time_zone
  end

  def event_l10n
    @event_l10n ||= event.localization_for(language)
  end

  def hugo_slug_in_website(website)
    event_l10n.slug
  end

  protected

  # Override from Permalinkable/Sluggable
  def slug_unavailable?(slug)
    self.class.unscoped
              .where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug)
              .where(about_id: about_id)
              .where.not(id: self.id)
              .exists?
  end

  # Override from Permalinkable/Sluggable
  # DD-hh-mm
  # 14-16-00
  def set_slug
    self.slug = "#{from_day&.strftime("%d")}-#{from_hour&.strftime('%H-%M')}"
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end
end
