# == Schema Information
#
# Table name: administration_academic_years
#
#  id            :uuid             not null, primary key
#  deleted_at    :datetime
#  year          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_administration_academic_years_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_7d376afe35  (university_id => universities.id)
#
class Administration::AcademicYear < ApplicationRecord
  acts_as_paranoid

  include AsIndirectObject
  include GeneratesGitFiles
  include Localizable
  include LocalizableOrderByNameScope
  include Sanitizable
  include Searchable
  include HasUniversity

  has_many  :administration_cohorts,
            class_name: 'Administration::Cohort'
  alias_method :cohorts, :administration_cohorts

  # Dénormalisation des alumni pour le faceted search
  has_and_belongs_to_many   :university_people,
                            class_name: 'University::Person',
                            foreign_key: :administration_academic_year_id,
                            association_foreign_key: :university_person_id
  has_many :people,
           class_name: 'University::Person',
           through: :administration_cohorts

  validates :year, numericality: { only_integer: true, greater_than: 0 }

  after_create_commit :create_localizations

  scope :ordered, -> (language = nil) { order(year: :desc) }

  def cohorts_in_context(context)
    return Administration::Cohort.none unless context.respond_to?(:cohorts)
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

  protected

  def create_localizations
    university.languages.each do |language|
      localizations.where(
        university: university,
        language: language
      ).first_or_create
    end
  end

end
