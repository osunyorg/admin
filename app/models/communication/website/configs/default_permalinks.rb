class Communication::Website::Configs::DefaultPermalinks < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::DefaultPermalinks'
  end

  def git_path(website)
    "config/_default/permalinks.yaml"
  end

  def template_static
    "admin/communication/websites/configs/default_permalinks/static"
  end

end
