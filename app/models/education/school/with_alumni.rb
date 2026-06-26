module Education::School::WithAlumni
  extend ActiveSupport::Concern

  included do

      has_many    :administration_cohorts,
                  class_name: 'Administration::Cohort',
                  dependent: :destroy
                  alias_method :cohorts, :administration_cohorts

      has_many    :alumni, -> { distinct },
                  through: :administration_cohorts,
                  source: :people
                  alias_method :university_person_alumni, :alumni

      has_many    :alumni_experiences, -> { distinct },
                  class_name: 'University::Person::Experience',
                  through: :alumni,
                  source: :experiences
                  alias_method :university_person_experiences, :alumni_experiences

      has_many    :alumni_organizations, -> { distinct },
                  class_name: 'University::Organization',
                  through: :alumni_experiences,
                  source: :organization
                  alias_method :university_person_alumni_organizations, :alumni_organizations

      has_many    :academic_years, -> { distinct },
                  class_name: 'Administration::AcademicYear',
                  through: :administration_cohorts,
                  source: :academic_year
                  alias_method :administration_academic_years, :academic_years

  end
end
