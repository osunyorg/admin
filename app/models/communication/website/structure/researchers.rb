class Communication::Website::Structure::Researchers < Communication::Website::Structure

  def self.polymorphic_name
    'Communication::Website::Structure::Researchers'
  end

  def git_path(website)
    "content/researchers/_index.html"
  end

end
