class Communication::Website::Permalink::Organization < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_organizations?
  end

  def self.static_config_key
    :organizations
  end

  # /organisations/:slug/
  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::Organization, language: language).slug_with_ancestors}/:slug/"
  end
end
