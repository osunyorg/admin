module University::Person::WithAlumnus
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many       :cohorts,
                                  class_name: '::Education::Cohort',
                                  foreign_key: :university_person_id,
                                  association_foreign_key: :education_cohort_id
    accepts_nested_attributes_for :cohorts,
                                  reject_if: :all_blank,
                                  allow_destroy: true
    before_validation :find_cohorts
    validates_associated :cohorts

    # Dénormalisation des liens via cohorts, pour la recherche par facettes
    has_and_belongs_to_many       :diploma_years,
                                  class_name: 'Education::AcademicYear',
                                  foreign_key: :university_person_id,
                                  association_foreign_key: :education_academic_year_id

    has_and_belongs_to_many       :diploma_programs,
                                  class_name: 'Education::Program',
                                  foreign_key: :university_person_id,
                                  association_foreign_key: :education_program_id

    has_many                      :experiences,
                                  class_name: "University::Person::Experience",
                                  dependent: :destroy

    accepts_nested_attributes_for :experiences,
                                  reject_if: :all_blank,
                                  allow_destroy: true

    validates_associated :experiences

    scope :for_alumni_organization, -> (organization_ids, language = nil) {
      left_joins(:experiences)
        .where(university_person_experiences: { organization_id: organization_ids })
        .select("university_people.*")
        .distinct
    }

    scope :for_alumni_program, -> (program_ids, language = nil) {
      left_joins(:cohorts)
        .where(education_cohorts: { program_id: program_ids })
        .select("university_people.*")
        .distinct
    }
    scope :for_alumni_year, -> (academic_year_ids, language = nil) {
      left_joins(:cohorts)
        .where(education_cohorts: { academic_year_id: academic_year_ids })
        .select("university_people.*")
        .distinct
    }
  end

  def add_to_cohort(cohort)
    cohorts << cohort unless cohort.in?(cohorts)
    diploma_years << cohort.academic_year unless cohort.academic_year.in? diploma_years
    diploma_programs << cohort.program unless cohort.program.in? diploma_programs
  end

  def find_cohorts
    # based on https://stackoverflow.com/questions/3579924/accepts-nested-attributes-for-with-find-or-create
    cohorts = []
    cohorts_ids = []
    self.cohorts.map do |object|
      academic_year = Education::AcademicYear.where(university_id: university_id, year: object.year).first_or_create
      cohort = Education::Cohort.where(university_id: university_id, school_id: object.school_id, program_id: object.program_id, academic_year_id: academic_year.id).first_or_initialize
      return unless cohort.valid?
      cohort.save if cohort.new_record?
      unless cohorts_ids.include?(cohort.reload.id) || object._destroy
        cohorts_ids << cohort.id unless cohort.id.nil?
        cohorts << cohort
      end
    end
    self.cohorts = cohorts
  end
end