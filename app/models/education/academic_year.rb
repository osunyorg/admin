# == Schema Information
#
# Table name: education_academic_years
#
#  id            :uuid             not null, primary key
#  year          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_education_academic_years_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_7d376afe35  (university_id => universities.id)
#
class Education::AcademicYear < ApplicationRecord
  include AsIndirectObject
  include GeneratesGitFiles
  include Localizable
  include LocalizableOrderByNameScope
  include Sanitizable
  include Searchable
  include WebsitesLinkable
  include WithUniversity

  has_many  :education_cohorts,
            class_name: 'Education::Cohort'
  alias_method :cohorts, :education_cohorts

  # Dénormalisation des alumni pour le faceted search
  has_and_belongs_to_many   :university_people,
                            class_name: 'University::Person',
                            foreign_key: :education_academic_year_id,
                            association_foreign_key: :university_person_id
  has_many :people,
           class_name: 'University::Person',
           through: :education_cohorts

  validates :year, numericality: { only_integer: true, greater_than: 0 }

  scope :ordered, -> (language = nil) { order(year: :desc) }

  def cohorts_in_context(context)
    return Education::Cohort.none unless context.respond_to?(:cohorts)
    cohorts.where(id: context.cohorts.pluck(:id))
  end

  def alumni_in_context(context)
    return University::Person.none unless context.respond_to?(:alumni)
    people.where(id: context.alumni.pluck(:id))
  end
  
  def dependencies
    localizations
  end

  def to_s
    "#{year}"
  end

end
