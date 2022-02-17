class Communication::Website::IndexPage::Home < Communication::Website::IndexPage
  def self.polymorphic_name
    'Communication::Website::IndexPage::Home'
  end

  def git_path(website)
    'content/_index.html'
  end

end
