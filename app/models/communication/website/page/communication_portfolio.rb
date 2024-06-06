class Communication::Website::Page::CommunicationPortfolio < Communication::Website::Page

  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def is_necessary_for_website?
    website.feature_portfolio
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.projects.where(language_id: language_id)
  end

  def git_path_relative
    'projects/_index.html'
  end
end
