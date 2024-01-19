class Communication::Website::Permalink::Administrator < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_administrators?
  end

  def self.static_config_key
    :administrators
  end

  # /equipe/:slug/roles/
  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::Person, language: language).slug_with_ancestors}/:slug/roles/"
  end
end
