class Communication::Website::Permalink::Program < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_education_programs?
  end

  def self.static_config_key
    :programs
  end

  # /formations/:slug/
  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::EducationProgram, language: language).slug_with_ancestors}/:slug/"
  end
end
