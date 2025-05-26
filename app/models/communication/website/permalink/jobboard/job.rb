class Communication::Website::Permalink::Jobboard::Job < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.feature_jobboard
  end

  def self.static_config_key
    :jobs
  end

  def self.pattern_in_website(website, language, about = nil)
    special_page_path(website, language) + '/:year/:slug/'
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationAgenda
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published
  end

  def substitutions
    {
      year: about.about.from_day.strftime("%Y"),
      slug: about.slug
    }
  end

end
