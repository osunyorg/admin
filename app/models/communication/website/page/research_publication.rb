class Communication::Website::Page::ResearchPublication < Communication::Website::Page

  def is_necessary_for_website?
    website.connected_publications.any?
  end

  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.connected_publications
  end

  def git_path_relative
    'publications/_index.html'
  end
end
