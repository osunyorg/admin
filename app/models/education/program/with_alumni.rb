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
               through: :alumni,
               source: :experiences
               alias_attribute :university_person_experiences, :alumni_experiences

    has_many   :alumni_organizations, -> { distinct },
               through: :alumni_experiences,
               source: :organization
               alias_attribute :university_person_alumni_organizations, :alumni_organizations

    # Dénormalisation des alumni pour le faceted search
    has_and_belongs_to_many :university_people,
               class_name: 'University::Person',
               foreign_key: 'education_program_id',
               association_foreign_key: 'university_person_id'

    # NOTE: Find a fix for wrong table name on WHERE clause
    #   SELECT "education_academic_years".*
    #   FROM "education_academic_years"
    #   INNER JOIN "education_cohorts"
    #     ON "education_academic_years"."id" = "education_cohorts"."academic_year_id"
    #   WHERE "cohorts"."program_id" = '<uuid>'
    #
    # has_many   :academic_years,
    #            class_name: 'Education::AcademicYear',
    #            through: :education_cohorts,
    #            source: :education_academic_year
    #            alias_attribute :education_academic_years, :academic_years

    def academic_years
      Education::AcademicYear.where(id: cohorts.pluck(:academic_year_id))
    end
  end
end
