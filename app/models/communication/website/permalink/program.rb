class Communication::Website::Permalink::Program < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_education_programs?
  end

  def self.static_config_key
    :programs
  end

  # /formations/:slug/
  def self.pattern_in_website(website, language)
    "/#{slug_with_ancestors(website, language)}/:slug/"
  end

  def special_page_type
    Communication::Website::Page::EducationProgram
  end

  protected

  def substitutions
    {
      slug: about.path
    }
  end
end
