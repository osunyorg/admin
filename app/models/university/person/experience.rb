# == Schema Information
#
# Table name: university_person_experiences
#
#  id              :uuid             not null, primary key
#  description     :text
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
  include WithUniversity

  attr_accessor :organization_name

  belongs_to :person
  belongs_to :organization, class_name: "University::Organization"

  before_validation :create_organization_if_needed

  scope :ordered, -> { order(from_year: :desc)}

  def to_s
    persisted?  ? "#{description}"
                : self.class.human_attribute_name('new')
  end

  def organization_name
    @organization_name || organization&.name
  end

  private

  def create_organization_if_needed
    if organization.nil? && organization_name.present?
      self.organization_name = self.organization_name.strip
      self.organization = university.organizations
                          .where("name ILIKE ?", organization_name)
                          .or(university.organizations.where(siren: organization_name)).first_or_create do |organization|
        organization.created_from_extranet = true
      end
    end
  end
end
