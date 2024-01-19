class Communication::Website::Configs::DevelopmentConfig < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::DevelopmentConfig'
  end

  def git_path(website)
    "config/development/config.yaml"
  end

  def template_static
    "admin/communication/websites/configs/development_config/static"
  end

end
