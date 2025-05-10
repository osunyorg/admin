class Communication::Website::Permalink::Agenda::Period::Year < Communication::Website::Permalink
  def self.static_config_key
    :events
  end

  def self.pattern_in_website(website, language, about = nil)
    pattern = special_page_path(website, language)
    pattern += '/:year/'
    pattern
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
      year: about.slug
    }
  end

end
