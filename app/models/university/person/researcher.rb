class University::Person::Researcher < University::Person
  def self.polymorphic_name
    'University::Person::Researcher'
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}researchers/#{slug}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/university/people/researchers/static"
  end

  def dependencies
    [person] +
    research_publications
  end

  def references
    research_journal_papers
  end
end
