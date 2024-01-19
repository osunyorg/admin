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
    "/#{website.special_page(Communication::Website::Page::Person, language: language).slug_with_ancestors}/:slug/programs/"
  end
end
