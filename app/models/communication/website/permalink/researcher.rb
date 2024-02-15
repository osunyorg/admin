class Communication::Website::Permalink::Researcher < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_researchers?
  end

  def self.static_config_key
    :researchers
  end

  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::Person, language: language).slug_with_ancestors}/:slug/publications/"
  end
end
