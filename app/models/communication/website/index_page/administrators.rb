class Communication::Website::IndexPage::Administrators < Communication::Website::IndexPage
  def self.polymorphic_name
    'Communication::Website::IndexPage::Administrators'
  end

  def git_path(website)
    'content/administrators/_index.html'
  end

  def url
    "/#{website.index_for(:persons).path}/#{website.index_for(:administrators).path}/"
  end

end
