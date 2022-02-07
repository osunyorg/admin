class Communication::Website::Structure::Teachers < Communication::Website::Structure

  def self.polymorphic_name
    'Communication::Website::Structure::Teachers'
  end

  def git_path(website)
    "content/teachers/_index.html"
  end

end
