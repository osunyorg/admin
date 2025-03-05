class Communication::Website::Permalink::Agenda::Event::TimeSlot < Communication::Website::Permalink

  # /agenda/2025/03/19-vel-anetha/
  def self.pattern_in_website(website, language, about = nil)
    "#{special_page_path(website, language)}/:year/:month/:day-:slug/'"
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
      year: about.from_day.strftime("%Y"),
      month: about.from_day.strftime("%m"),
      day: about.from_day.strftime("%d"),
      slug: about.slug
    }
  end

end
