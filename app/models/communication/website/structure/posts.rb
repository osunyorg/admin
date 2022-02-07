class Communication::Website::Structure::Posts < Communication::Website::Structure

  def self.polymorphic_name
    'Communication::Website::Structure::Posts'
  end

  def git_path(website)
    "content/posts/_index.html"
  end

end
