class Communication::Website::Permalink::Portfolio::Project < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.feature_portfolio
  end

  def self.static_config_key
    :projects
  end

  # /projets/2022-lac-project/
  def self.pattern_in_website(website, language)
    special_page_path(website, language) + '/:year-:slug/'
  end

  def self.special_page_type
    Communication::Website::Page::CommunicationPortfolio
  end

  protected

  def published?
    website.id == about.communication_website_id && about.published
  end

  def substitutions
    {
      year: about.about.year,
      slug: about.slug
    }
  end

end
