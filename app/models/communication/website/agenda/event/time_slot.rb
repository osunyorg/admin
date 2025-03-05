# == Schema Information
#
# Table name: communication_website_agenda_event_time_slots
#
#  id                                    :uuid             not null, primary key
#  datetime                              :datetime
#  duration                              :integer
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
  include Localizable
  include WithUniversity

  belongs_to  :communication_website_agenda_event,
              class_name: 'Communication::Website::Agenda::Event'
  alias :event :communication_website_agenda_event

  validates :datetime, presence: true

  scope :on_year, -> (year) { where('extract(year from datetime) = ?', year) }
  scope :on_month, -> (year, month) { where('extract(year from datetime) = ? and extract(month from datetime) = ?', year, month) }
  scope :on_day, -> (day) {  where('DATE(datetime) = ?', day) }

  scope :ordered, -> { order(:datetime) }

  delegate :time_zone, to: :event

  def dependencies
    localizations.in_languages(website.active_language_ids)
  end

  def date
    datetime.to_date
  end
  alias :from_day :date # Used by Communication::Website::Agenda::Period::InPeriod

  def time
    datetime.strftime("%H:%M")
  end

  def end_datetime
    return if duration.to_i.zero?
    datetime + duration.seconds
  end

  def end_date
    end_datetime&.to_date
  end
  alias :to_day :end_date # Used by Communication::Website::Agenda::Period::InPeriod

  def end_time
    end_datetime&.strftime("%H:%M")
  end

  protected

  # Methods for Communication::Website::Agenda::Period::InPeriod

  def day_changed?
    datetime_changed?
  end

  def day_before_change
    datetime_change.first&.to_date
  end

  def day_after_change
    datetime_change.last&.to_date
  end
end
