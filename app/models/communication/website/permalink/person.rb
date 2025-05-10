class Communication::Website::Permalink::Person < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_persons?
  end

  def self.static_config_key
    :persons
  end

  # /equipe/:slug/
  def self.pattern_in_website(website, language, about = nil)
    special_page_path(website, language) + '/:slug/'
  end

  def self.special_page_type
    Communication::Website::Page::Person
  end
end
