# == Schema Information
#
# Table name: communication_website_agenda_event_days
#
#  id                                    :uuid             not null, primary key
#  date                                  :date
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  communication_website_agenda_event_id :uuid             not null, indexed
#  communication_website_id              :uuid             not null, indexed
#  language_id                           :uuid             not null, indexed
#  university_id                         :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_agenda_event_id_4defccd002         (communication_website_agenda_event_id)
#  idx_on_communication_website_id_38a3895ffa                      (communication_website_id)
#  index_communication_website_agenda_event_days_on_language_id    (language_id)
#  index_communication_website_agenda_event_days_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_282cc6c244  (communication_website_agenda_event_id => communication_website_agenda_events.id)
#  fk_rails_5660af0762  (language_id => languages.id)
#  fk_rails_628702ad2a  (university_id => universities.id)
#  fk_rails_9a3c150837  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Event::Day < ApplicationRecord
  include AsDirectObject
  include Permalinkable
  include WithUniversity
  include WithGitFiles

  belongs_to  :event,
              foreign_key: :communication_website_agenda_event_id
  belongs_to  :language

  delegate :to_s, :title, :subtitle, :summary, :contents_full_text, to: :event_l10n, allow_nil: true
  delegate :best_bodyclass, to: :event

  scope :for_language, -> (language) { where(language: language) }
  scope :ordered, -> { order(:date) }

  def git_path(website)
    return if website.id != communication_website_id || # Wrong website, should never happen
              events.none? || # Nothing this day
              event_l10n.nil? || # Event not localized in this language
              !event_l10n.published # Event not published
    git_path_content_prefix(website) + git_path_relative
  end

  # events/2025/arte-concert-festival/2025-01-02.html
  def git_path_relative
    "events/#{event.from_day.strftime "%Y"}/#{event_l10n.slug}/#{date.strftime "%Y-%m-%d"}.html"
  end

  def template_static
    "admin/communication/websites/agenda/events/days/static"
  end

  def events
    event.children.where(from_day: date)
  end

  def event_l10n
    return unless event.localized_in?(language)
    event.localization_for(language)
  end

  def from_day
    date
  end

  protected

  # Override from Permalinkable/Sluggable
  def skip_slug_validation?
    true # Slug is in event_l10n
  end

  # Override from Permalinkable/Sluggable
  def set_slug
    # Slug is in event_l10n
  end

  # Override from Permalinkable/Staticable
  def hugo_slug_in_website(website)
    event_l10n.try(:slug)
  end
end
