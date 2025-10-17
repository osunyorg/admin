class Communication::Website::Page::ResearchVolume < Communication::Website::Page

  def is_hugo_index?
    true
  end

  def should_create_special_page?
    website.about && website.about&.respond_to?(:volumes)
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.research_volumes
  end

  def git_path_relative
    'volumes/_index.html'
  end
end
