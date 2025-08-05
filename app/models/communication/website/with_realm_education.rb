module Communication::Website::WithRealmEducation
  extend ActiveSupport::Concern

  def blocks_from_education
    Communication::Block.where(about: education_programs).or(
      Communication::Block.where(about: education_diplomas)
    )
  end

  def education_schools
    has_education_schools? ? about.schools : Education::School.none
  end

  def education_diplomas
    has_education_diplomas? ? about.diplomas : Education::Diploma.none
  end

  def education_programs
    has_education_programs? ? about.programs : Education::Program.none
  end

  def teachers
    has_teachers? ? about.teachers : University::Person.none
  end

  def has_teachers?
    about && about.has_teachers?
  end

  def has_education_schools?
    about && about.has_education_schools?
  end

  def has_education_diplomas?
    about && about.has_education_diplomas?
  end

  def has_education_programs?
    about && about.has_education_programs?
  end

end
