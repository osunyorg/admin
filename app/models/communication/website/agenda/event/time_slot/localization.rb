# == Schema Information
#
# Table name: communication_website_agenda_event_time_slot_localizations
#
#  id                       :uuid             not null, primary key
#  add_to_calendar_urls     :jsonb
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
  include AsLocalization
  include Permalinkable
  include WithGitFiles
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  alias :time_slot :about

  delegate :event, to: :about
  delegate :title, :subtitle, :summary, :current_permalink_url_in_website, to: :event_l10n
  delegate :archive?, to: :event

  # /content/fr/events/YYYY/MM/DD-hh-mm-slug.html
  def git_path(website)
    return unless website.id == communication_website_id
    git_path_content_prefix(website) + git_path_relative
  end

  # events/YYYY/MM/DD-hh-mm-slug.html
  def git_path_relative
    "events/#{from_day.strftime "%Y/%m"}/#{slug}.html"
  end

  def template_static
    "admin/communication/websites/agenda/events/static"
  end

  def from_day
    about.datetime.to_date
  end

  def from_hour
    about.datetime.to_time
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

  # DD-hh-mm-slug
  # 14-16-00-contes-a-paillettes
  def set_slug
    self.slug = "#{from_day.strftime "%d"}-#{from_hour.strftime '%H-%M'}-#{event_l10n.slug}"
  end

  protected

  def skip_slug_validation?
    true
  end
end
