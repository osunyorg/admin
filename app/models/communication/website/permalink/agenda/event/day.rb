class Communication::Website::Permalink::Agenda::Event::Day < Communication::Website::Permalink

  # /agenda/2025/arte-concert-festival/
  def self.pattern_in_website(website, language, about = nil)
    "#{special_page_path(website, language)}/:year/:slug:federation_suffix/"
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationAgenda
  end

  protected

  def published?
    about.published_in?(website)
  end

  def substitutions
    event = about.event
    {
      year: about.from_day.strftime("%Y"),
      slug: about.event_l10n.slug,
      federation_suffix: event.suffix_in(website)
    }
  end

end
