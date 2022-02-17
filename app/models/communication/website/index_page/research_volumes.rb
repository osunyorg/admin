class Communication::Website::IndexPage::ResearchVolumes < Communication::Website::IndexPage
  def self.polymorphic_name
    'Communication::Website::IndexPage::ResearchVolumes'
  end

  def git_path(website)
    'content/volumes/_index.html'
  end

  def url
    "/#{website.index_for(:research_volumes).path}/"
  end

end
