# -*- SkipSchemaAnnotations
class Communication::Website::Configs::NodcConfig < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::NodcConfig'
  end

  def git_path(website)
    "quix.toml"
  end

  def template_static
    "admin/communication/websites/configs/nodc_config/static"
  end

end
