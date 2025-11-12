class Communication::Website::Page::EducationSchool < Communication::Website::Page

  def is_hugo_index?
    true
  end

  def should_create_special_page?
    website.about && website.about&.respond_to?(:education_schools)
  end

  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def full_width
    true
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.education_schools
  end

  def git_path_relative
    'schools/_index.html'
  end
end
