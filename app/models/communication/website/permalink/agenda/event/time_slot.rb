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
    if about.kind_children?
      parent = about.parent
      {
        year: parent.from_day.strftime("%Y"),
        slug: "#{parent.slug}/#{about.slug}"
      }
    else
      {
        year: about.from_day.strftime("%Y"),
        slug: about.slug
      }
    end
  end

end
