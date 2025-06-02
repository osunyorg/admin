class Communication::Website::Permalink::Agenda::Event < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.feature_agenda
  end

  def self.static_config_key
    :events
  end

  def self.pattern_in_website(website, language, about = nil)
    pattern = special_page_path(website, language)
    if about&.kind_child?
      # /agenda/2025/arte-concert-festival/priya-ragu/
      pattern += '/:parent_year/:parent_slug:federation_suffix/:slug:federation_suffix/'
    elsif about&.kind_parent?
      # /agenda/2025/arte-concert-festival/
      pattern += '/:year/:slug:federation_suffix/'
    else
      # /agenda/2025/vel-anetha/
      pattern += '/:year/:slug:federation_suffix/'
    end
    pattern
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationAgenda
  end

  protected

  def published?
    about.event.allowed_in?(website) && about.published
  end

  def substitutions
    parent = about.parent
    event = about.event
    {
      parent_year: parent&.from_day&.strftime("%Y"),
      parent_slug: parent&.slug,
      year: about.from_day.strftime("%Y"),
      month: about.from_day.strftime("%m"),
      day: about.from_day.strftime("%d"),
      slug: about.slug,
      federation_suffix: event.suffix_in(website)
    }
  end

end
