class Communication::Website::Permalink::Agenda::Event::Day < Communication::Website::Permalink
  def self.pattern_in_website(website, language, about = nil)
    # /agenda/2025/arte-concert-festival/
    "#{special_page_path(website, language)}/:year/:slug/"
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationAgenda
  end

  protected

  def published?
    website.id == about.communication_website_id && # Good website
      about.events.any? && # With events on this day
      about.event_l10n.present? && # Event localized in this language
      about.event_l10n.published? # and published
  end

  def substitutions
    {
      year: about.from_day.strftime("%Y"),
      slug: about.event_l10n.slug
    }
  end

end
