class Communication::Website::Page::ResearchLaboratory < Communication::Website::Page

  def is_hugo_index?
    true
  end

  def should_create_special_page?
    website.about && website.about&.respond_to?(:laboratories)
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.research_laboratories
  end

  def git_path_relative
    'laboratories/_index.html'
  end
end
