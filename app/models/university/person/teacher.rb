class University::Person::Teacher < University::Person

  def self.polymorphic_name
    'University::Person::Teacher'
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}teachers/#{slug}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/university/people/teachers/static"
  end

  def dependencies
    [person]
  end

  def references
    education_programs_as_teacher
  end
end
