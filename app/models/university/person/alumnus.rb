class University::Person::Alumnus < University::Person
  def self.polymorphic_name
    'University::Person::Alumnus'
  end

  # No alumni on websites
  def should_publish_to?(website)
    false
  end

  def template_static
    "admin/university/people/alumni/static"
  end

end
