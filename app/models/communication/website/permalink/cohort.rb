class Communication::Website::Permalink::Cohort < Communication::Website::Permalink
  def self.required_in_config?(website)
    website.has_alumni?
  end

  def self.static_config_key
    :cohorts
  end

  # /alumni/2020/metiers-du-multimedia-et-de-l-internet
  def self.pattern_in_website(website, language, about = nil)
    special_page_path(website, language) + '/:year/:program_slug'
  end

  def self.special_page_type
    Communication::Website::Page::EducationAcademicYear
  end

  protected

  def substitutions
    {
      year: about.academic_year.year,
      program_slug: about.program_l10n.slug
    }
  end
end
