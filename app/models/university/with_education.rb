module University::WithEducation
  extend ActiveSupport::Concern

  included do
    has_many  :education_cohorts,
              class_name: 'Education::Cohort',
              dependent: :destroy
    alias_attribute :cohorts, :education_cohorts

    has_many  :education_programs,
              class_name: 'Education::Program',
              dependent: :destroy
    alias_attribute :programs, :education_programs

    has_many  :education_schools,
              class_name: 'Education::School',
              dependent: :destroy
    alias_attribute :schools, :education_schools

    has_many  :education_academic_years,
              class_name: 'Education::AcademicYear',
              dependent: :destroy
    alias_attribute :academic_years, :education_academic_years
  end
end
