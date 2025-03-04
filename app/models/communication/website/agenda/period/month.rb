# == Schema Information
#
# Table name: communication_website_agenda_period_months
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
#  idx_on_communication_website_id_49eaf81807                   (communication_website_id)
#  idx_on_university_id_f680736f97                              (university_id)
#  index_communication_website_agenda_period_months_on_year_id  (year_id)
#
# Foreign Keys
#
#  fk_rails_912208071c  (university_id => universities.id)
#  fk_rails_b9b2c3a105  (communication_website_id => communication_websites.id)
#  fk_rails_d1531afc39  (year_id => communication_website_agenda_period_years.id)
#
class Communication::Website::Agenda::Period::Month < ApplicationRecord
  include AsDirectObject
  include Localizable
  include WithUniversity

  belongs_to :year

  scope :ordered, -> { order(value: :asc) }
  default_scope { ordered }

  after_save :create_all_localizations
  after_touch :create_all_localizations

  def self.table_name
    'communication_website_agenda_period_months'
  end

  # Entry point for everything
  def self.connect(object)
    year = Communication::Website::Agenda::Period::Year.connect(object)
    month = Communication::Website::Agenda::Month.where(
      university: object.university,
      website: object.website,
      year: year,
      value: object.from_day.month
    ).first_or_create
    month
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

  def to_date
    @to_date ||= Date.new(year.value, value, 1)
  end

  protected

  def create_all_localizations
    available_languages.each do |language|
      localizations.where(
        university: university,
        website: website,
        language: language
      ).first_or_create
    end
  end
end
