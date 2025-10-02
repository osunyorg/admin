class Communication::Website::Page::EducationAcademicYear < Communication::Website::Page

  def is_hugo_index?
    true
  end

  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def should_create_special_page?
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
