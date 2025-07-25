class Communication::Website::Page::ResearchPaper < Communication::Website::Page

  def should_create_special_page?
    website.about && website.about&.respond_to?(:papers)
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.research_papers
  end

  def git_path_relative
    'papers/_index.html'
  end
end
