class Communication::Website::Page::ResearchPaper < Communication::Website::Page

  def is_necessary_for_website?
    website.about && website.about&.respond_to?(:papers)
  end

  # TODO: Scope .where(language_id: language_id) when papers are translatable
  def dependencies
    super +
    [website.config_default_languages] +
    website.research_papers
  end

  def git_path_relative
    'papers/_index.html'
  end
end
