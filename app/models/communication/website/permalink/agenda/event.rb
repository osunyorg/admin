class Communication::Website::Permalink::Agenda::Event < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.feature_agenda
  end

  def self.static_config_key
    :events
  end

  # /agenda/2022-10-21-un-article/
  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::CommunicationAgenda, language: language).slug_with_ancestors}/:year-:month-:day-:slug/"
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published
  end

  def substitutions
    {
      year: about.from_day.strftime("%Y"),
      month: about.from_day.strftime("%m"),
      day: about.from_day.strftime("%d"),
      slug: about.slug
    }
  end

end
