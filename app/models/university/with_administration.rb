module University::WithAdministration
  extend ActiveSupport::Concern

  included do
    has_many  :administration_locations,
              class_name: 'Administration::Location',
              dependent: :destroy
    alias_method :locations, :administration_locations

    has_many  :administration_academic_years,
              class_name: 'Administration::AcademicYear',
              dependent: :destroy
    alias_method :academic_years, :administration_academic_years

    has_many  :administration_cohorts,
              class_name: 'Administration::Cohort',
              dependent: :destroy
    alias_method :cohorts, :administration_cohorts
  end
end
