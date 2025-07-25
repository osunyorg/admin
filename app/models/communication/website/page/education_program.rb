class Communication::Website::Page::EducationProgram < Communication::Website::Page

  def should_create_special_page?
    website.about && website.about&.respond_to?(:programs)
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
    website.education_programs
  end

  def git_path_relative
    'programs/_index.html'
  end

  def special_page_categories
    university.education_program_categories
  end
end
