class Communication::Website::Page::EducationDiploma < Communication::Website::Page

  def is_necessary_for_website?
    website.about && website.about&.respond_to?(:education_diplomas)
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
    website.education_diplomas
  end

  def git_path_relative
    'diplomas/_index.html'
  end
end
