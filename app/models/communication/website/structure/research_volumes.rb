class Communication::Website::Structure::ResearchVolumes < Communication::Website::Structure

  def self.polymorphic_name
    'Communication::Website::Structure::ResearchVolumes'
  end

  def git_path(website)
    "content/volumes/_index.html"
  end

end
