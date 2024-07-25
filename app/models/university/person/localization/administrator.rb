class University::Person::Localization::Administrator < University::Person::Localization
  def self.polymorphic_name
    'University::Person::Localization::Administrator'
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}administrators/#{slug}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/university/people/administrators/static"
  end

  def dependencies
    [
      person_localization,
      person_localization.about
    ]
  end

  def references
    education_programs_as_administrator
  end

  def static_localization_key
    # so we don't mess with the University::Person::Localization static_localization_key
    "#{about.class.polymorphic_name.parameterize}-administrator-#{self.about_id}"
  end
end
