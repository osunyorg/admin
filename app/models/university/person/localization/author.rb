class University::Person::Localization::Author < University::Person::Localization
  def self.polymorphic_name
    'University::Person::Localization::Author'
  end

  def git_path_relative
    "authors/#{slug}/_index.html"
  end

  def template_static
    "admin/university/people/authors/static"
  end

  def dependencies
    [
      person_l10n,
      person
    ]
  end

  def references
    person.communication_website_posts
  end

  def static_localization_key
    # so we don't mess with the University::Person::Localization static_localization_key
    "#{about.class.polymorphic_name.parameterize}-author-#{self.about_id}"
  end

end
