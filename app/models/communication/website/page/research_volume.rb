class Communication::Website::Page::ResearchVolume < Communication::Website::Page

  def is_necessary_for_website?
    website.about && website.about&.respond_to?(:volumes)
  end

  # TODO: Scope .where(language_id: language_id) when volumes are translatable
  def dependencies
    super +
    [website.config_default_languages] +
    website.research_volumes
  end

  protected

  def current_git_path
    @current_git_path ||= "#{git_path_prefix}volumes/_index.html"
  end

end
