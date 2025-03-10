# == Schema Information
#
# Table name: communication_website_agenda_period_months
#
#  id                       :uuid             not null, primary key
#  value                    :integer          indexed => [university_id, communication_website_id, year_id]
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed, indexed => [university_id, year_id, value]
#  university_id            :uuid             not null, indexed, indexed => [communication_website_id, year_id, value]
#  year_id                  :uuid             not null, indexed, indexed => [university_id, communication_website_id, value]
#
# Indexes
#
#  idx_on_communication_website_id_49eaf81807                   (communication_website_id)
#  idx_on_university_id_f680736f97                              (university_id)
#  index_communication_website_agenda_period_months_on_year_id  (year_id)
#  index_communication_website_agenda_period_months_unique      (university_id,communication_website_id,year_id,value) UNIQUE
#
# Foreign Keys
#
#  fk_rails_912208071c  (university_id => universities.id)
#  fk_rails_b9b2c3a105  (communication_website_id => communication_websites.id)
#  fk_rails_d1531afc39  (year_id => communication_website_agenda_period_years.id)
#
class Communication::Website::Agenda::Period::Month < ApplicationRecord
  include AsDirectObject
  include Communication::Website::Agenda::Period::Base
  include Localizable
  include WithUniversity

  belongs_to :year
  has_many :days, dependent: :destroy

  after_create :create_days

  def first_day
    @first_day ||= Date.new(year.value, value, 1)
  end

  def dependencies
    [website.config_default_content_security_policy] +
    localizations.in_languages(website.active_language_ids)
  end

  protected

  def create_days
    date = first_day.dup
    while date.month == first_day.month
      Communication::Website::Agenda::Period::Day.where(
        university: university,
        website: website,
        year: year,
        month: self,
        value: date.day
      ).first_or_create do |day|
        day.date = date
      end
      date += 1.day
      puts "Created day #{date}"
    end
  end

end
