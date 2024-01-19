class University::Person::Administrator < University::Person
  def self.polymorphic_name
    'University::Person::Administrator'
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}administrators/#{slug}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/university/people/administrators/static"
  end

  def dependencies
    [person]
  end

  def references
    education_programs_as_administrator
  end
end
