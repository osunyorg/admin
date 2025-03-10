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
  include Communication::Website::Agenda::Period::Base
  include Localizable
  include WithUniversity

  after_create :create_months

  has_many :months, dependent: :destroy
  has_many :days, dependent: :destroy

  scope :ordered, -> { order(value: :desc) }

  def self.exists_for?(website, value)
    exists?(
      university: website.university,
      website: website,
      value: value
    )
  end

  def self.create_for(website, value)
    return if exists_for?(website, value)
    year = where(
      university: website.university,
      website: website,
      value: value
    ).first_or_create
    year.save_and_sync
    year
  end

  def dependencies
    [website.config_default_content_security_policy] +
    localizations.in_languages(website.active_language_ids) +
    months
  end

  protected

  def create_months
    12.times do |index|
      month = Communication::Website::Agenda::Period::Month.where(
        university: university,
        website: website,
        year: self,
        value: index + 1
      ).create
      puts "Created month #{month}"
    end
  end
end
