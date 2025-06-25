class Communication::Website::Page::EducationAcademicYear < Communication::Website::Page

  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def is_necessary_for_website?
    website.feature_alumni
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.alumni
  end

  def git_path_relative
    'academic_years/_index.html'
  end

end
