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
  include WithUniversity

  after_create :create_months
  
  has_many :months

  scope :ordered, -> { order(value: :desc) }
  default_scope { ordered }

  def events
    website.events.in_year(value)
  end

  def last_two_digits
    to_s.last(2)
  end

  def to_s
    "#{value}"
  end

  protected
  
  def create_months
    12.times { |index|
      Communication::Website::Agenda::Month.create(
        university: university,
        website: website,
        year: self,
        value: index + 1
      )
    }
  end
end
