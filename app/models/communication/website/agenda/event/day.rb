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
  include Communication::Website::Agenda::Period::InPeriod
  include Communication::Website::Agenda::WithStatus
  include HasGitFiles
  include Permalinkable
  include WithUniversity

  belongs_to  :event,
              foreign_key: :communication_website_agenda_event_id
  belongs_to  :language

  delegate :to_s, :title, :subtitle, :summary, :contents_full_text, to: :event_l10n, allow_nil: true
  delegate :best_bodyclass, to: :event

  scope :for_language, -> (language) { where(language: language) }
  scope :ordered, -> { order(:date) }

  # events/2025/01/02-arte-concert-festival.html
  def git_path_relative
    "events/#{event.from_day.strftime "%Y"}/#{date.strftime "%m/%d"}-#{event_l10n.slug}#{event.suffix_in(website)}.html"
  end

  def should_sync_to?(website)
    event.allowed_in?(website) && # Good website or federated
    website.active_language_ids.include?(language_id) && # Language is active on website
    events.any? && # With events on this day
    event_l10n.present? && # Event localized in this language
    event_l10n.published? # and published
  end

  def template_static
    "admin/communication/websites/agenda/events/days/static"
  end

  def events
    @events ||= event.children.on_day(date)
  end

  def event_l10n
    unless @event_l10n
      if event.localized_in?(language)
        @event_l10n = event.localization_for(language)
      end
    end
    @event_l10n
  end

  def from_day
    date
  end

  def to_day
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
