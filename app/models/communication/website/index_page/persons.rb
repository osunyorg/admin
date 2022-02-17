class Communication::Website::IndexPage::Persons < Communication::Website::IndexPage
  def self.polymorphic_name
    'Communication::Website::IndexPage::Persons'
  end

  def git_path(website)
    'content/persons/_index.html'
  end

  def url
    "/#{website.index_for(:persons).path}/"
  end

end
