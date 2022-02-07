class Communication::Website::Structure::Authors < Communication::Website::Structure

  def self.polymorphic_name
    'Communication::Website::Structure::Authors'
  end

  def git_path(website)
    "content/authors/_index.html"
  end

end
