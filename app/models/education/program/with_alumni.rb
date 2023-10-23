module Education::Program::WithAlumni
  extend ActiveSupport::Concern

  included do
    has_many   :education_cohorts,
               class_name: 'Education::Cohort'
               alias_method :cohorts, :education_cohorts

    has_many   :alumni,
               through: :education_cohorts,
               source: :people
               alias_method :university_person_alumni, :alumni

    has_many   :alumni_experiences, -> { distinct },
               through: :alumni,
               source: :experiences
               alias_method :university_person_experiences, :alumni_experiences

    has_many   :alumni_organizations, -> { distinct },
               through: :alumni_experiences,
               source: :organization
               alias_method :university_person_alumni_organizations, :alumni_organizations

    # Dénormalisation des alumni pour le faceted search
    has_and_belongs_to_many :university_people,
               class_name: 'University::Person',
               foreign_key: :education_program_id,
               association_foreign_key: :university_person_id

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
    #            alias_method :education_academic_years, :academic_years

    def academic_years
      Education::AcademicYear.where(id: education_cohorts.pluck(:academic_year_id))
    end
    alias :education_academic_years :academic_years
  end
end
