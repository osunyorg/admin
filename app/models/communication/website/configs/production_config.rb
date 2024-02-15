class Communication::Website::Configs::ProductionConfig < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::ProductionConfig'
  end

  def git_path(website)
    "config/production/config.yaml"
  end

  def template_static
    "admin/communication/websites/configs/production_config/static"
  end

end
