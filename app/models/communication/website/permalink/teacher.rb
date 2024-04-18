class Communication::Website::Permalink::Teacher < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_teachers?
  end

  def self.static_config_key
    :teachers
  end

  # /equipe/:slug/programs/
  # FIXME
  def self.pattern_in_website(website, language)
    "/#{slug_with_ancestors(website, language)}/:slug/programs/"
  end

  def special_page_type
    Communication::Website::Page::Person
  end
end
