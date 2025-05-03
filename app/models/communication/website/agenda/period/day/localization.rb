# == Schema Information
#
# Table name: communication_website_agenda_period_day_localizations
#
#  id                       :uuid             not null, primary key
#  events_count             :integer          default(0)
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
#  idx_on_about_id_ff7b8b96ea                  (about_id)
#  idx_on_communication_website_id_c9cc20d97c  (communication_website_id)
#  idx_on_language_id_1d8b40b5f3               (language_id)
#  idx_on_university_id_55f80b8bba             (university_id)
#
# Foreign Keys
#
#  fk_rails_44de397628  (university_id => universities.id)
#  fk_rails_48be7f66dc  (about_id => communication_website_agenda_period_days.id)
#  fk_rails_75d26f9b9a  (language_id => languages.id)
#  fk_rails_a4f13fe1c0  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Period::Day::Localization < ApplicationRecord
  include AsDirectObject
  include AsLocalization
  include WithUniversity

  belongs_to  :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  after_save_commit :denormalize_events_count

  delegate :value, :date, to: :about
  delegate :cwday, :day, :iso8601, to: :date

  def events
    @events ||=  website.events
                        .on_day(date)
                        .with_no_time_slots
  end

  def time_slots
    @time_slots ||= website.time_slots.on_day(date)
  end

  def events?
    events_count > 0
  end

  def next
    about.next&.localized_in(language)
  end

  def to_full_name
    I18n.localize(date, locale: language.iso_code, format: '%A %d %B %Y').humanize
  end

  def to_s
    I18n.localize(date, locale: language.iso_code, format: '%A').humanize
  end

  protected

  def denormalize_events_count
    count = events.count + time_slots.count
    self.update_column :events_count, count
  end
end
