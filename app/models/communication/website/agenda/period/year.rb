# == Schema Information
#
# Table name: communication_website_agenda_period_years
#
#  id                       :uuid             not null, primary key
#  needs_checking           :boolean          default(FALSE)
#  value                    :integer          uniquely indexed => [university_id, communication_website_id]
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed, uniquely indexed => [university_id, value]
#  university_id            :uuid             not null, uniquely indexed => [communication_website_id, value]
#
# Indexes
#
#  idx_on_communication_website_id_dd738e97d3              (communication_website_id)
#  index_communication_website_agenda_period_years_unique  (university_id,communication_website_id,value) UNIQUE
#
# Foreign Keys
#
#  fk_rails_3b2775135a  (university_id => universities.id)
#  fk_rails_67a8039d71  (communication_website_id => communication_websites.id)
#
class Communication::Website::Agenda::Period::Year < ApplicationRecord
  include AsDirectObject
  include Communication::Website::Agenda::Period::Base
  include GeneratesGitFiles
  include Localizable
  include WithUniversity

  after_create :create_months
  before_save :set_needs_checking

  has_many :months, dependent: :destroy
  has_many :days, dependent: :destroy

  scope :ordered, -> { order(value: :desc) }
  scope :needing_recheck, -> { where(needs_checking: true) }

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
    year.save
    year
  end

  def dependencies
    [website.config_default_content_security_policy] +
    localizations.in_languages(website.active_language_ids) +
    months
  end

  def previous
    Communication::Website::Agenda::Period::Year.find_by(
      university: university,
      website: website,
      value: value - 1
    )
  end

  def next
    Communication::Website::Agenda::Period::Year.find_by(
      university: university,
      website: website,
      value: value + 1
    )
  end

  def empty?
    events_with_no_time_slots.none? && time_slots.none?
  end

  def events_with_no_time_slots
    website.events
           .with_no_time_slots
           .on_year(value)
  end

  def time_slots
    website.time_slots
           .on_year(value)
  end

  def needs_recheck!
    update_column :needs_checking, true
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

  def set_needs_checking
    self.needs_checking = true
  end
end
