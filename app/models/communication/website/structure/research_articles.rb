class Communication::Website::Structure::ResearchArticles < Communication::Website::Structure

  def self.polymorphic_name
    'Communication::Website::Structure::ResearchArticles'
  end

  def git_path(website)
    "content/articles/_index.html"
  end

end
