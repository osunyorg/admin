class Communication::Website::Page::EducationProgram < Communication::Website::Page

  def is_necessary_for_website?
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

  # TODO: Scope .where(language_id: language_id) when programs are translatable
  def dependencies
    super +
    [website.config_default_languages] +
    website.education_programs
  end

  protected

  def current_git_path
    @current_git_path ||= "#{git_path_prefix}programs/_index.html"
  end

end
