class University::Person::Localization::Teacher < University::Person::Localization

  def self.polymorphic_name
    'University::Person::Localization::Teacher'
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}teachers/#{slug}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/university/people/teachers/static"
  end

  def dependencies
    [
      localization,
      localization.about
    ]
  end

  def references
    education_programs_as_teacher
  end

  def static_localization_key
    # so we don't mess with the University::Person::Localization static_localization_key
    "#{about.class.polymorphic_name.parameterize}-teacher-#{self.about_id}"
  end
end
