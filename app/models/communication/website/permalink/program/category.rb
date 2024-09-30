class Communication::Website::Permalink::Program::Category < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_programs?
  end

  def self.static_config_key
    :programs_categories
  end

  # /formations/categories/:slug/
  def self.pattern_in_website(website, language)
    special_page_path(website, language) + '/categories/:slug/'
  end

  def self.special_page_type
    Communication::Website::Page::EducationProgram
  end

  protected

  def substitutions
    {
      slug: about.slug
    }
  end

end
