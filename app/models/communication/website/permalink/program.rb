class Communication::Website::Permalink::Program < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_education_programs?
  end

  def self.static_config_key
    :programs
  end

  # /formations/:slug/
  def self.pattern_in_website(website)
    "#{website.special_page(:education_programs).path_without_language}:slug/"
  end
end
