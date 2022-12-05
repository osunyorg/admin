class Communication::Website::Permalink::Person < Communication::Website::Permalink
  def self.required_for_website?(website)
    website.has_persons?
  end

  def self.static_config_key
    :persons
  end

  def self.pattern_in_website(website)
    "#{website.special_page(:persons).path_without_language}:slug/"
  end
end
