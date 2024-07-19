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
end
