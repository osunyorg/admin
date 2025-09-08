class Communication::Website::Permalink::Agenda::Event::TimeSlot < Communication::Website::Permalink

  delegate  :event, :event_l10n,
            to: :about

  # Récurrent
  # /fr/agenda/YYYY/slug/
  # Récurrent enfant
  # /fr/agenda/YYYY/parent_slug/slug/
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
    if event.kind_child?
      parent_event_l10n = event_l10n.parent
      parent_event = parent_event_l10n.about
      {
        year: parent_event.from_day.strftime("%Y"),
        slug: "#{parent_event_l10n.slug}/#{event_l10n.slug}",
        federation_suffix: event.suffix_in(website)
      }
    else
      {
        year: event.from_day.strftime("%Y"),
        slug: event_l10n.slug,
        federation_suffix: event.suffix_in(website)
      }
    end
  end

end
