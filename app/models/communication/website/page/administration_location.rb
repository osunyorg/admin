class Communication::Website::Page::AdministrationLocation < Communication::Website::Page

  def is_necessary_for_website?
    website.about && website.about&.respond_to?(:administration_locations)
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
    website.administration_locations
  end

  protected

  def current_git_path
    @current_git_path ||= "#{git_path_prefix}locations/_index.html"
  end

end
