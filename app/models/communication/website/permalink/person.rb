class Communication::Website::Permalink::Person < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_persons?
  end

  def self.static_config_key
    :persons
  end

  def self.pattern_in_website(website)
    "#{website.special_page(:persons).path_without_language}:slug/"
  end

  protected

  def published?
    about.for_website?(website)
  end

  def published_path
    pattern.gsub(":slug", about.slug)
  end
end
