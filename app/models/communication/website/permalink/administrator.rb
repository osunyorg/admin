class Communication::Website::Permalink::Administrator < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_administrators?
  end

  def self.static_config_key
    :administrators
  end

  # /equipe/:slug/roles/
  def self.pattern_in_website(website, language)
    "/#{slug_with_ancestors(website, language)}/:slug/roles/"
  end

  def special_page_type
    Communication::Website::Page::Person
  end
end
