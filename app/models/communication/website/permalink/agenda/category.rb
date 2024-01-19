class Communication::Website::Permalink::Agenda::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.feature_agenda
  end

  def self.static_config_key
    :events_categories
  end

  # /agenda/:slug/
  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::CommunicationAgenda, language: language).slug_with_ancestors}/:slug/"
  end

  protected

  def published?
    website.id == about.communication_website_id
  end

  def substitutions
    {
      slug: about.slug
    }
  end

end
