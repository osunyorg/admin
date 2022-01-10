class University::Person::Researcher < University::Person
  def self.polymorphic_name
    'University::Person::Researcher'
  end

  def git_path(website)
    "content/researchers/#{slug}/_index.html" if for_website?(website)
  end

  def for_website?(website)
    # TODO
    is_researcher
  end
end
