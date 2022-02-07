class Communication::Website::Structure::Persons < Communication::Website::Structure

  def self.polymorphic_name
    'Communication::Website::Structure::Persons'
  end

  def git_path(website)
    "content/persons/_index.html"
  end

end
