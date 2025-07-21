class University::Person::Alumnus < University::Person
  def self.polymorphic_name
    'University::Person::Alumnus'
  end

  # No alumni on websites, we use people
  def has_git_file?
    false
  end

  def template_static
    "admin/university/people/alumni/static"
  end

end
