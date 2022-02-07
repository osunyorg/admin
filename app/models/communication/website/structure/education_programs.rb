class Communication::Website::Structure::EducationPrograms < Communication::Website::Structure

  def self.polymorphic_name
    'Communication::Website::Structure::EducationPrograms'
  end

  def git_path(website)
    "content/programs/_index.html"
  end

end
