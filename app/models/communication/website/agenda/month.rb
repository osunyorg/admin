# == Schema Information
#
# Table name: communication_website_agenda_months
#
#  id                       :uuid             not null, primary key
#  value                    :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#  year_id                  :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_93f9d5408c                  (communication_website_id)
#  index_communication_website_agenda_months_on_university_id  (university_id)
#  index_communication_website_agenda_months_on_year_id        (year_id)
#
# Foreign Keys
#
#  fk_rails_912208071c  (university_id => universities.id)
#  fk_rails_b9b2c3a105  (communication_website_id => communication_websites.id)
#  fk_rails_d1531afc39  (year_id => communication_website_agenda_years.id)
#
class Communication::Website::Agenda::Month < ApplicationRecord
  include AsDirectObject
  include WithUniversity

  belongs_to :year

  scope :ordered, -> { order(value: :asc) }
  default_scope { ordered }

  def events
    website.events.in_month(year.value, value)
  end

  def days
    unless @days
      @days = []
      current_date = to_date.dup
      while current_date.month == to_date.month
        @days << current_date
        current_date += 1.day
      end
    end
    @days
  end

  def events_for(day)
    website.events.in_day(day)
  end

  def to_date
    @to_date ||= Date.new(year.value, value, 1)
  end

  def to_s
    I18n.t("date.month_names")[value].titleize
  end
end
