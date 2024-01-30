class Communication::Website::Permalink::Location < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_administration_locations?
  end

  def self.static_config_key
    :locations
  end

  # /campus/:slug/
  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::AdministrationLocation, language: language).slug_with_ancestors}/:slug/"
  end
end
