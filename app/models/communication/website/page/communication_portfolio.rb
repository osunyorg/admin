class Communication::Website::Page::CommunicationPortfolio < Communication::Website::Page

  def design_options_block_template_kind
    :projects
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
end
