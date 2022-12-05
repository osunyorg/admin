class Communication::Website::Permalink::Organization < Communication::Website::Permalink
  def self.required_for_website?(website)
    website.has_organizations?
  end

  def self.static_config_key
    :organizations
  end

  def self.pattern_in_website(website)
    "#{website.special_page(:organizations).path_without_language}:slug/"
  end

  protected

  def published?
    about.for_website?(website)
  end

  def published_path
    pattern.gsub(":slug", about.slug)
  end
end
