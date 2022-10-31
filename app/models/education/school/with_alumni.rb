module Education::School::WithAlumni
  extend ActiveSupport::Concern

  included do

      has_many    :education_cohorts,
                  class_name: 'Education::Cohort'
                  alias_attribute :cohorts, :education_cohorts

      has_many    :alumni, -> { distinct },
                  through: :education_cohorts,
                  source: :people
                  alias_attribute :university_person_alumni, :alumni

      has_many    :alumni_experiences, -> { distinct },
                  class_name: 'University::Person::Experience',
                  through: :alumni,
                  source: :experiences
                  alias_attribute :university_person_experiences, :alumni_experiences

      has_many    :alumni_organizations, -> { distinct },
                  class_name: 'University::Organization',
                  through: :alumni_experiences,
                  source: :organization
                  alias_attribute :university_person_alumni_organizations, :alumni_organizations

      has_many    :academic_years, -> { distinct },
                  class_name: 'Education::AcademicYear',
                  through: :education_cohorts,
                  source: :academic_year
                  alias_attribute :education_academic_years, :academic_years

  end
end
