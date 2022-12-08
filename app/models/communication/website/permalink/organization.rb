class Communication::Website::Permalink::Organization < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_organizations?
  end

  def self.static_config_key
    :organizations
  end

  # /organisations/:slug/
  def self.pattern_in_website(website)
    "#{website.special_page(:organizations).path_without_language}:slug/"
  end
end
