class Communication::Website::IndexPage::Teachers < Communication::Website::IndexPage
  def self.polymorphic_name
    'Communication::Website::IndexPage::Teachers'
  end

  def git_path(website)
    'content/teachers/_index.html'
  end

  def url
    "/#{website.index_for(:persons).path}/#{website.index_for(:teachers).path}/"
  end

end
