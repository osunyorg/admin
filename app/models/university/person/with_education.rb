module University::Person::WithEducation
  extend ActiveSupport::Concern

  included do
    has_many                :involvements_as_teacher,
                            -> { where(kind: 'teacher') },
                            class_name: 'University::Person::Involvement',
                            dependent: :destroy

    has_many                :education_programs_as_teacher,
                            through: :involvements_as_teacher,
                            source: :target,
                            source_type: "Education::Program"

    has_many                :experiences

    has_and_belongs_to_many :cohorts,
                            class_name: 'Education::Cohort',
                            foreign_key: 'university_person_id',
                            association_foreign_key: 'education_cohort_id'

    # Dénormalisation des liens via cohorts, pour la recherche par facettes
    has_and_belongs_to_many :diploma_years,
                            class_name: 'Education::AcademicYear',
                            foreign_key: 'university_person_id',
                            association_foreign_key: 'education_academic_year_id'
    has_and_belongs_to_many :diploma_programs,
                            class_name: 'Education::Program',
                            foreign_key: 'university_person_id',
                            association_foreign_key: 'education_program_id'
  end

  def education_programs_as_administrator
    university.education_programs
              .joins(:involvements_through_roles)
              .where(university_person_involvements: { person_id: id })
              .distinct
  end

  def add_to_cohort(cohort)
    cohorts << cohort unless cohort.in?(cohorts)
    diploma_years << cohort.academic_year unless cohort.academic_year.in? diploma_years
    diploma_programs << cohort.program unless cohort.program.in? diploma_programs
  end
end
