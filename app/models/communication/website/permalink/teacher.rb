class Communication::Website::Permalink::Teacher < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_teachers?
  end

  def self.static_config_key
    :teachers
  end

  # /equipe/:slug/programs/
  # FIXME : Remplacer le programs comme dans Permalink::Author ?
  def self.pattern_in_website(website, language)
    "/#{special_page_path(website, language)}/:slug/programs/"
  end

  def self.special_page_type
    Communication::Website::Page::Person
  end
end
