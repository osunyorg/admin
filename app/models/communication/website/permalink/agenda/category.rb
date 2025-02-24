class Communication::Website::Permalink::Agenda::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.feature_agenda
  end

  def self.static_config_key
    :events_categories
  end

  # /agenda/:slug/
  def self.pattern_in_website(website, language, about = nil)
    special_page_path(website, language) + '/:slug/'
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationAgenda
  end

  protected

  def published?
    website.id == about.communication_website_id
  end

  def substitutions
    {
      slug: about.slug_with_ancestors_slugs
    }
  end

end
