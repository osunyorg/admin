class Communication::Website::Page::CommunicationPortfolio < Communication::Website::Page

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
    website.feature_portfolio
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.projects
  end

  def git_path_relative
    'projects/_index.html'
  end

  def special_page_categories
    website.portfolio_categories
  end

  def hugo_body_class
    'projects__section'
  end
end
