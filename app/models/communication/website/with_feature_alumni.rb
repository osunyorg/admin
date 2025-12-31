module Communication::Website::WithFeatureAlumni
  extend ActiveSupport::Concern

  def can_have_feature_alumni?
    about_type == Education::School.name || about_type == Education::Program.name
  end

  def alumni
    has_alumni? ? about.alumni : University::Person.none
  end

  def cohorts
    has_alumni? ? about.cohorts : Education::Cohort.none
  end

  def alumni_programs
    return Education::Program.none unless has_alumni?
    program_ids = education_programs
                    .joins(:education_cohorts)
                    .where(education_cohorts: { id: cohorts.pluck(:id) })
                    .distinct
                    .pluck(:id)
    education_programs.where(id: program_ids)
  end

  def academic_years
    has_alumni? ? about.academic_years : Education::AcademicYear.none
  end

  def has_alumni?
    about.present? && feature_alumni && about.alumni.any?
  end

  def feature_alumni_dependencies
    return [] unless has_alumni?
    alumni +
    cohorts +
    academic_years
  end
end
