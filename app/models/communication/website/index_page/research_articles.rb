class Communication::Website::IndexPage::ResearchArticles < Communication::Website::IndexPage
  def self.polymorphic_name
    'Communication::Website::IndexPage::ResearchArticles'
  end

  def git_path(website)
    'content/articles/_index.html'
  end

  def url
    "/#{website.index_for(:research_articles).path}/"
  end

end
