class University::Person::Localization::Administrator < University::Person::Localization
  def self.polymorphic_name
    'University::Person::Localization::Administrator'
  end

  def git_path_relative
    "administrators/#{slug}/_index.html"
  end

  def template_static
    "admin/university/people/administrators/static"
  end

  def dependencies
    [
      person_l10n,
      person
    ]
  end

  def references
    person.education_programs_as_administrator
  end

  def static_localization_key
    # so we don't mess with the University::Person::Localization static_localization_key
    "#{about.class.polymorphic_name.parameterize}-administrator-#{self.about_id}"
  end

end
