class Communication::Website::Permalink::Researcher < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_researchers?
  end

  def self.static_config_key
    :researchers
  end

  def self.pattern_in_website(website)
    "#{website.special_page(:persons).path_without_language}:slug/papers/"
  end

  protected

  def published?
    about.for_website?(website)
  end

  def published_path
    pattern.gsub(":slug", about.slug)
  end
end
