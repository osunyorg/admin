class Communication::Website::Structure::Administrators < Communication::Website::Structure

  def self.polymorphic_name
    'Communication::Website::Structure::Administrators'
  end

  def git_path(website)
    "content/administrators/_index.html"
  end

end
