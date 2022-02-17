class Communication::Website::IndexPage::Researchers < Communication::Website::IndexPage
  def self.polymorphic_name
    'Communication::Website::IndexPage::Researchers'
  end

  def git_path(website)
    'content/researchers/_index.html'
  end

  def url
    "/#{website.index_for(:persons).path}/#{website.index_for(:researchers).path}/"
  end

end
