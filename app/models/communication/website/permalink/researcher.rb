class Communication::Website::Permalink::Researcher < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_researchers?
  end

  def self.static_config_key
    :researchers
  end

  # FIXME : Remplacer le publications comme dans Permalink::Author ?
  def self.pattern_in_website(website, language)
    "/#{special_page_path(website, language)}/:slug/publications/"
  end

  def self.special_page_type
    Communication::Website::Page::Person
  end
end
