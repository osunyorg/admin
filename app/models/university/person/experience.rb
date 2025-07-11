# == Schema Information
#
# Table name: university_person_experiences
#
#  id              :uuid             not null, primary key
#  from_year       :integer
#  to_year         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :uuid             not null, indexed
#  person_id       :uuid             not null, indexed
#  university_id   :uuid             not null, indexed
#
# Indexes
#
#  index_university_person_experiences_on_organization_id  (organization_id)
#  index_university_person_experiences_on_person_id        (person_id)
#  index_university_person_experiences_on_university_id    (university_id)
#
# Foreign Keys
#
#  fk_rails_18125d90df  (person_id => university_people.id)
#  fk_rails_38aaa18a3b  (organization_id => university_organizations.id)
#  fk_rails_923d0b71fd  (university_id => universities.id)
#
class University::Person::Experience < ApplicationRecord
  include Localizable
  include WithUniversity

  attr_accessor :organization_name

  belongs_to :person
  belongs_to :organization, class_name: "University::Organization"

  validates :from_year, presence: true
  validate :to_year, :not_before_from_year

  after_validation :deport_error_on_organization

  scope :current, -> { where('from_year <= :current_year AND (to_year IS NULL OR to_year >= :current_year)', current_year: Date.current.year) }
  scope :ordered, -> (language = nil) { order('university_person_experiences.to_year DESC NULLS FIRST, university_person_experiences.from_year') }
  scope :latest, -> {
    where.not(from_year: nil)
    .order(from_year: :desc, created_at: :desc)
    .limit(10)
  }

  private

  def not_before_from_year
    if to_year.present? && to_year < from_year
      errors.add :to_year
    end
  end

  def deport_error_on_organization
    if errors[:organization].present? && organization_name
      errors.add :organization_name, :required
    end
  end

end
