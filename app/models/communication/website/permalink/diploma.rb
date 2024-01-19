class Communication::Website::Permalink::Diploma < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_education_diplomas?
  end

  def self.static_config_key
    :diplomas
  end

  # /diplomes/:slug/
  def self.pattern_in_website(website, language)
    "/#{website.special_page(Communication::Website::Page::EducationDiploma, language: language).slug_with_ancestors}/:slug/"
  end
end
