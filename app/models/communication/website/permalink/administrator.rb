class Communication::Website::Permalink::Administrator < Communication::Website::Permalink
  def self.required_for_website?(website)
    website.has_administrators?
  end

  def self.static_config_key
    :administrators
  end

  def self.pattern_in_website(website)
    "#{website.special_page(:persons).path_without_language}:slug/roles/"
  end

  protected

  def published?
    about.for_website?(website)
  end

  def published_path
    pattern.gsub(":slug", about.slug)
  end
end
