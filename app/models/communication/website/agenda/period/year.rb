# == Schema Information
#
# Table name: communication_website_agenda_period_years
#
#  id                       :uuid             not null, primary key
#  value                    :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_dd738e97d3  (communication_website_id)
#  idx_on_university_id_2c377eb7c0             (university_id)
#
# Foreign Keys
#
#  fk_rails_3b2775135a  (university_id => universities.id)
#  fk_rails_67a8039d71  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Period::Year < ApplicationRecord
  include AsDirectObject
  include Localizable
  include WithUniversity

  after_save :create_months
  after_save :create_all_localizations
  after_touch :create_all_localizations

  has_many :months

  scope :ordered, -> { order(value: :desc) }
  default_scope { ordered }

  def self.connect(object)
    Communication::Website::Agenda::Period::Year.where(
      university: object.university,
      website: object.website,
      value: object.from_day.year
    ).first_or_create
  end

  protected
  
  def create_months
    12.times { |index|
      month = Communication::Website::Agenda::Period::Month.where(
        university: university,
        website: website,
        year: self,
        value: index + 1
      ).first_or_create
    }
  end

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
