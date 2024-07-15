class Communication::Website::Permalink::Organization < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_organizations?
  end

  def self.static_config_key
    :organizations
  end

  # /organisations/:slug/
  def self.pattern_in_website(website, language)
    "/#{special_page_path(website, language)}/:slug/"
  end

  def self.special_page_type
    Communication::Website::Page::Organization
  end
end
