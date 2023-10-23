module University::WithEducation
  extend ActiveSupport::Concern

  included do
    has_many  :education_cohorts,
              class_name: 'Education::Cohort',
              dependent: :destroy
    alias_method :cohorts, :education_cohorts

    has_many  :education_diplomas,
              class_name: 'Education::Diploma',
              dependent: :destroy
    alias_method :diplomas, :education_diplomas

    has_many  :education_programs,
              class_name: 'Education::Program',
              dependent: :destroy
    alias_method :programs, :education_programs

    has_many  :education_schools,
              class_name: 'Education::School',
              dependent: :destroy
    alias_method :schools, :education_schools

    has_many  :education_academic_years,
              class_name: 'Education::AcademicYear',
              dependent: :destroy
    alias_method :academic_years, :education_academic_years
  end
end
