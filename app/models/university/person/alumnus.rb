class University::Person::Alumnus < University::Person
  def self.polymorphic_name
    'University::Person::Alumnus'
  end

  def template_static
    "admin/university/people/alumni/static"
  end

  def git_path(website)
    # No alumni on websites
  end
end
