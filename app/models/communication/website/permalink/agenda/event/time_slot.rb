class Communication::Website::Permalink::Agenda::Event::TimeSlot < Communication::Website::Permalink

  # Récurrent
  # /fr/agenda/YYYY/slug/
  # Récurrent enfant
  # /fr/agenda/YYYY/parent_slug/slug/
  def self.pattern_in_website(website, language, about = nil)
    "#{special_page_path(website, language)}/:year/:slug/"
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationAgenda
  end

  protected

  def published?
    website.id == about.communication_website_id
  end

  def substitutions
    event_l10n = about.event_l10n
    event = event_l10n.about
    if event.kind_child?
      parent_event_l10n = event_l10n.parent
      parent_event = parent_event_l10n.about
      {
        year: parent_event.from_day.strftime("%Y"),
        slug: "#{parent_event_l10n.slug}/#{event_l10n.slug}"
      }
    else
      {
        year: event.from_day.strftime("%Y"),
        slug: event_l10n.slug
      }
    end
  end

end
