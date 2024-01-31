class Communication::Website::Permalink::Publication < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.connected_hal_publications.any?
  end

  def self.static_config_key
    :publications
  end

  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::ResearchPublication, language: language).slug_with_ancestors}/:year-:slug/"
  end

  protected

  def substitutions
    {
      year: about.publication_date.strftime("%Y"),
      slug: about.slug
    }
  end
end
