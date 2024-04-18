class Communication::Website::Permalink::Researcher < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_researchers?
  end

  def self.static_config_key
    :researchers
  end

  def self.pattern_in_website(website, language)
    "/#{slug_with_ancestors(website, language)}/:slug/publications/"
  end

  def special_page_type
    Communication::Website::Page::Person
  end
end
