# == Schema Information
#
# Table name: communication_website_agenda_years
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
#  idx_on_communication_website_id_5597ee5d02                 (communication_website_id)
#  index_communication_website_agenda_years_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_3b2775135a  (university_id => universities.id)
#  fk_rails_67a8039d71  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Year < ApplicationRecord
  include AsDirectObject
  include Localizable
  include WithUniversity

  # TODO optimize
  after_save :create_months
  after_save :create_all_localizations
  after_touch :create_all_localizations

  has_many :months

  scope :ordered, -> { order(value: :desc) }
  default_scope { ordered }

  def self.connect(object)
    year = Communication::Website::Agenda::Year.where(
      university: object.university,
      website: object.website,
      value: object.from_day.year
    ).first_or_create
    languages = object.website.languages
    languages.each do |language|
      year.localizations.where(
        university: object.university,
        website: object.website,
        language: language
      ).first_or_create
    end
    year
  end

  def events
    website.events.in_year(value)
  end

  protected
  
  def create_months
    12.times { |index|
      month = Communication::Website::Agenda::Month.where(
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
