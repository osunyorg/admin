class Communication::Website::Configs::BaseUrl < Communication::Website

  def self.polymorphic_name
    'Communication::Website::Configs::BaseUrl'
  end

  def git_path(website)
    "config/production/config.yaml"
  end

end
