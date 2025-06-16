# == Schema Information
#
# Table name: education_cohorts
#
#  id               :uuid             not null, primary key
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  academic_year_id :uuid             not null, indexed
#  program_id       :uuid             not null, indexed
#  school_id        :uuid             not null, indexed
#  university_id    :uuid             not null, indexed
#
# Indexes
#
#  index_education_cohorts_on_academic_year_id  (academic_year_id)
#  index_education_cohorts_on_program_id        (program_id)
#  index_education_cohorts_on_school_id         (school_id)
#  index_education_cohorts_on_university_id     (university_id)
#
# Foreign Keys
#
#  fk_rails_0f4a4f43d9  (university_id => universities.id)
#  fk_rails_72528c3d76  (program_id => education_programs.id)
#  fk_rails_8545767e2d  (school_id => education_schools.id)
#  fk_rails_c2d725cabd  (academic_year_id => education_academic_years.id)
#
class Education::Cohort < ApplicationRecord
  include AsIndirectObject
  include GeneratesGitFiles
  include Localizable
  include LocalizableOrderByNameScope
  include Sanitizable
  include Searchable
  include WebsitesLinkable
  include WithUniversity

  belongs_to  :school,
              class_name: 'Education::School'
  alias_method :education_school, :school

  belongs_to  :program,
              class_name: 'Education::Program'
  alias_method :education_program, :program

  belongs_to  :academic_year,
              class_name: 'Education::AcademicYear'
  alias_method :education_academic_year, :academic_year

  has_and_belongs_to_many :people,
                          class_name: 'University::Person',
                          foreign_key: :education_cohort_id,
                          association_foreign_key: :university_person_id

  validates_associated :school, :academic_year, :program
  validates :year, presence: true

  scope :ordered, -> (language = nil) {
    includes(:academic_year).order('education_academic_years.year DESC')
  }

  def year
    academic_year&.year
  end

  def year=(value)
    self.academic_year = Education::AcademicYear.where(university_id: university_id, year: value).first_or_create
  end

  def dependencies
    localizations
  end

end
