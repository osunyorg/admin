class University::Person::Alumnus < University::Person
  def self.polymorphic_name
    'University::Person::Alumnus'
  end

  # No alumni on websites, we use people
  def syncable?
    false
  end

  def template_static
    "admin/university/people/alumni/static"
  end

end
