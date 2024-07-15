class Communication::Website::Permalink::Location < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_administration_locations?
  end

  def self.static_config_key
    :locations
  end

  # /campus/:slug/
  def self.pattern_in_website(website, language)
    "/#{special_page_path(website, language)}/:slug/"
  end

  def self.special_page_type
    Communication::Website::Page::AdministrationLocation
  end
end
