class Communication::Website::Permalink::AcademicYear < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_alumni?
  end

  def self.static_config_key
    :academic_years
  end

  # /formations/2020/
  def self.pattern_in_website(website, language, about = nil)
    special_page_path(website, language) + '/:year'
  end

  def self.special_page_type
    Communication::Website::Page::EducationProgram
  end

  protected

  def substitutions
    {
      year: about.year,
    }
  end
end
