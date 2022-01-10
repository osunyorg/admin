class University::Person::Teacher < University::Person
  def self.polymorphic_name
    'University::Person::Teacher'
  end

  def git_path(website)
    "content/teachers/#{slug}/_index.html" if for_website?(website)
  end

  def for_website?(website)
    is_teacher && website.programs
                          .published
                          .joins(:teachers)
                          .where(education_program_teachers: { person_id: id })
                          .any?
  end
end
