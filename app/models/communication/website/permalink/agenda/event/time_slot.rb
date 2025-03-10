class Communication::Website::Permalink::Agenda::Event::TimeSlot < Communication::Website::Permalink

  # Récurrent
  # /fr/agenda/YYYY/slug/
  # Récurrent enfant
  # /fr/agenda/YYYY/parent_slug/slug/
  def self.pattern_in_website(website, language, about = nil)
    "#{special_page_path(website, language)}/:year/:slug/'"
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationAgenda
  end

  protected

  def published?
    website.id == about.communication_website_id
  end

  def substitutions
    event = about.event
    if event.kind_children?
      parent_event = event.parent
      {
        year: parent_event.from_day.strftime("%Y"),
        slug: "#{parent_event.slug}/#{event.slug}"
      }
    else
      {
        year: event.from_day.strftime("%Y"),
        slug: event.slug
      }
    end
  end

end
