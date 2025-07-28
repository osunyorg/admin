class Communication::Website::Page::CommunicationJobboard < Communication::Website::Page

  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def should_create_special_page?
    website.feature_jobboard
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.jobs
  end

  def git_path_relative
    'jobs/_index.html'
  end

  def special_page_categories
    website.jobboard_categories
  end
end
