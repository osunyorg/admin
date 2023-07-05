class Communication::Website::Permalink::Publication < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_communication_posts?
  end

  def self.static_config_key
    :publications
  end

  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::ResearchHalPublication, language: language).slug_with_ancestors}/:year/:slug/"
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published && about.published_at
  end

  def substitutions
    {
      year: about.publication_date.strftime("%Y"),
      slug: about.slug
    }
  end
end
