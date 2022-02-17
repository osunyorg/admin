class Communication::Website::IndexPage::Authors < Communication::Website::IndexPage
  def self.polymorphic_name
    'Communication::Website::IndexPage::Authors'
  end

  def git_path(website)
    'content/authors/_index.html'
  end

  def url
    "/#{website.index_for(:persons).path}/#{website.index_for(:authors).path}/"
  end

end
