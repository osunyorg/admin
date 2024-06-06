class Communication::Website::Page::ResearchVolume < Communication::Website::Page

  def is_necessary_for_website?
    website.about && website.about&.respond_to?(:volumes)
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.research_volumes.where(language_id: language_id)
  end

  def git_path_relative
    'volumes/_index.html'
  end
end
