class Communication::Website::Permalink::Paper < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.about.is_a? Research::Journal
  end

  def self.static_config_key
    :papers
  end

  # /papiers/:slug/
  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::ResearchPaper, language: language).slug_with_ancestors}/:year-:month-:day-:slug/"
  end

  protected

  def published?
    about.published && about.published_at
  end

  def substitutions
    {
      year: about.published_at.strftime("%Y"),
      month: about.published_at.strftime("%m"),
      day: about.published_at.strftime("%d"),
      slug: about.slug
    }
  end
end
