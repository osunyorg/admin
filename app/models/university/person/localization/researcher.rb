class University::Person::Localization::Researcher < University::Person::Localization
  def self.polymorphic_name
    'University::Person::Localization::Researcher'
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}researchers/#{slug}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/university/people/researchers/static"
  end

  def dependencies
    [
      localization,
      localization.about
    ] +
    research_publications
  end

  def references
    research_journal_papers
  end
end
