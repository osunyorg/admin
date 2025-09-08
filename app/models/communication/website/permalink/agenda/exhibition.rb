class Communication::Website::Permalink::Agenda::Exhibition < Communication::Website::Permalink
  delegate :exhibition, to: :about

  def self.required_in_config?(website)
    website.feature_agenda
  end

  def self.static_config_key
    :exhibitions
  end

  # /expositions/2022-10-21-pulse/
  def self.pattern_in_website(website, language, about = nil)
    special_page_path(website, language) + '/:year-:month-:day-:slug:federation_suffix/'
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationAgendaExhibition
  end

  protected

  def substitutions
    {
      year: about.from_day.strftime("%Y"),
      month: about.from_day.strftime("%m"),
      day: about.from_day.strftime("%d"),
      slug: about.slug,
      federation_suffix: exhibition.suffix_in(website)
    }
  end

end
