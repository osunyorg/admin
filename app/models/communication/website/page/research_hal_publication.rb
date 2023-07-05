class Communication::Website::Page::ResearchHalPublication < Communication::Website::Page

  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.connected_hal_publications
  end

  protected

  def current_git_path
    @current_git_path ||= "#{git_path_prefix}publications/_index.html"
  end

end
