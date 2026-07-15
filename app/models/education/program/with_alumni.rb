module Education::Program::WithAlumni
  extend ActiveSupport::Concern

  included do
    has_many   :administration_cohorts,
               class_name: 'Administration::Cohort'
               alias_method :cohorts, :administration_cohorts

    has_many   :alumni,
               through: :administration_cohorts,
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
    # Pour mémoire, le nom de la table est education_programs_university_people
    has_and_belongs_to_many :university_people,
               class_name: 'University::Person',
               foreign_key: :education_program_id,
               association_foreign_key: :university_person_id

    # NOTE: Find a fix for wrong table name on WHERE clause
    #   SELECT "administration_academic_years".*
    #   FROM "administration_academic_years"
    #   INNER JOIN "administration_cohorts"
    #     ON "administration_academic_years"."id" = "administration_cohorts"."academic_year_id"
    #   WHERE "cohorts"."program_id" = '<uuid>'
    #
    # has_many   :academic_years,
    #            class_name: 'Administration::AcademicYear',
    #            through: :administration_cohorts,
    #            source: :administration_academic_year
    #            alias_method :administration_academic_years, :academic_years

    def academic_years
      Administration::AcademicYear.where(id: administration_cohorts.pluck(:academic_year_id))
    end
    alias :administration_academic_years :academic_years
  end
end
