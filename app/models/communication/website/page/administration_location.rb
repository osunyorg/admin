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
    website.administration_locations.where(language_id: language_id)
  end

  def git_path_relative
    'locations/_index.html'
  end
end
