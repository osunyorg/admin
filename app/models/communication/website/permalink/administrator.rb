class Communication::Website::Permalink::Administrator < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_administrators?
  end

  def self.static_config_key
    :administrators
  end

  # /equipe/:slug/roles/
  def self.pattern_in_website(website)
    "#{website.special_page(:persons).path_without_language}:slug/roles/"
  end
end
