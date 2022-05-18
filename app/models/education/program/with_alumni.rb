module Education::Program::WithAlumni
  extend ActiveSupport::Concern

  included do
    has_many   :cohorts,
               class_name: 'Education::Cohort'
               alias_attribute :education_cohorts, :cohorts

    has_many   :alumni,
               through: :cohorts,
               source: :people
               alias_attribute :university_person_alumni, :alumni

    has_many   :alumni_experiences, -> { distinct },
               class_name: 'University::Person::Experience',
               through: :alumni,
               source: :experiences
               alias_attribute :university_person_experiences, :alumni_experiences

    has_many   :alumni_organizations, -> { distinct },
               class_name: 'University::Organization',
               through: :alumni_experiences,
               source: :organization
               alias_attribute :university_person_alumni_organizations, :alumni_organizations

    has_many   :academic_years, -> { distinct },
               class_name: 'Education::AcademicYear',
               through: :cohorts,
               source: :academic_year
               alias_attribute :education_academic_years, :academic_years

    # Dénormalisation des alumni pour le faceted search
    has_and_belongs_to_many :university_people,
                            class_name: 'University::Person',
                            foreign_key: 'education_program_id',
                            association_foreign_key: 'university_person_id'
  end
end
