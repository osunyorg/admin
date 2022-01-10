class University::Person::Administrator < University::Person
  def self.polymorphic_name
    'University::Person::Administrator'
  end

  def git_path(website)
    "content/administrators/#{slug}/_index.html" if for_website?(website)
  end

  def for_website?(website)
    # TODO
    is_administrative
  end
end
