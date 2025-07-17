class University::Person::Localization::Teacher < University::Person::Localization

  def self.polymorphic_name
    'University::Person::Localization::Teacher'
  end

  def git_path_relative
    "teachers/#{slug}/_index.html"
  end

  def should_publish_to?(website)
    for_website?(website)
  end

  def template_static
    "admin/education/teachers/static"
  end

  def dependencies
    [
      person_l10n,
      person
    ]
  end

  def references
    person.education_programs_as_teacher
  end

  def static_localization_key
    # so we don't mess with the University::Person::Localization static_localization_key
    "#{about.class.polymorphic_name.parameterize}-teacher-#{self.about_id}"
  end

end
