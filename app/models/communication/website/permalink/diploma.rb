class Communication::Website::Permalink::Diploma < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_education_diplomas?
  end

  def self.static_config_key
    :diplomas
  end

  # /diplomes/:slug/
  def self.pattern_in_website(website, language, about = nil)
    special_page_path(website, language) + '/:slug/'
  end

  def self.special_page_type
    Communication::Website::Page::EducationDiploma
  end
end
