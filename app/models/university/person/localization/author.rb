class University::Person::Localization::Author < University::Person::Localization
  def self.polymorphic_name
    'University::Person::Localization::Author'
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}authors/#{slug}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/university/people/authors/static"
  end

  def dependencies
    [
      localization,
      localization.about
    ]
  end

  def references
    communication_website_posts
  end

  def static_localization_key
    # so we don't mess with the University::Person::Localization static_localization_key
    "#{about.class.polymorphic_name.parameterize}-author-#{self.about_id}"
  end
end
