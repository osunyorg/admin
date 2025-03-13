class Communication::Website::Permalink::Publication < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.connected_publications.any?
  end

  def self.static_config_key
    :publications
  end

  def self.pattern_in_website(website, language, about = nil)
    special_page_path(website, language) + '/:year-:slug/'
  end

  def self.special_page_type
    Communication::Website::Page::ResearchPublication
  end

  protected

  def substitutions
    {
      year: about.publication_date.strftime("%Y"),
      slug: about.slug
    }
  end
end
