# == Schema Information
#
# Table name: communication_website_agenda_event_time_slots
#
#  id                                    :uuid             not null, primary key
#  datetime                              :datetime
#  duration                              :integer
#  migration_identifier                  :string
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  communication_website_agenda_event_id :uuid             not null, indexed
#  communication_website_id              :uuid             not null, indexed
#  university_id                         :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_agenda_event_id_022d825cf7  (communication_website_agenda_event_id)
#  idx_on_communication_website_id_c0ac516bb5               (communication_website_id)
#  idx_on_university_id_bca328e63c                          (university_id)
#
# Foreign Keys
#
#  fk_rails_46fa7aa5f8  (university_id => universities.id)
#  fk_rails_4c8fd1bfaf  (communication_website_id => communication_websites.id)
#  fk_rails_7cb3bfe2bf  (communication_website_agenda_event_id => communication_website_agenda_events.id)
#
class Communication::Website::Agenda::Event::TimeSlot < ApplicationRecord
  include AsDirectObject
  include Communication::Website::Agenda::Period::InPeriod
  include GeneratesGitFiles
  include Localizable
  include WithOpenApi
  include WithUniversity

  belongs_to  :communication_website_agenda_event,
              class_name: 'Communication::Website::Agenda::Event',
              touch: true
  alias :event :communication_website_agenda_event

  validates :datetime, presence: true

  before_validation :set_website_and_university, on: :create

  scope :on_year, -> (year) { where('extract(year from datetime) = ?', year) }
  scope :on_month, -> (year, month) { where('extract(year from datetime) = ? and extract(month from datetime) = ?', year, month) }
  scope :on_day, -> (day) {  where('DATE(datetime) = ?', day) }

  scope :ordered, -> { order(:datetime) }

  delegate :time_zone, to: :event

  def dependencies
    localizations.in_languages(website.active_language_ids)
  end

  # Used by Communication::Website::Agenda::Period::InPeriod
  def from_day
    date
  end

  # Used by Communication::Website::Agenda::Period::InPeriod
  def to_day
    date
  end

  def date
    @date ||= datetime&.to_date
  end

  def time
    datetime&.strftime("%H:%M")
  end

  def end_datetime
    return if datetime.nil? || duration.to_i.zero?
    datetime + duration.seconds
  end

  def end_date
    end_datetime&.to_date
  end

  def end_time
    end_datetime&.strftime("%H:%M")
  end

  def first?
    @first ||= id == event.time_slots.ordered.first.id
  end

  protected

  # Methods for Communication::Website::Agenda::Period::InPeriod

  def should_update_periods?
    datetime_changed?
  end

  def day_before_change
    datetime_change.first&.to_date
  end

  def day_after_change
    datetime_change.last&.to_date
  end

  def set_website_and_university
    self.communication_website_id = event.communication_website_id
    self.university_id = event.university_id
  end
end
