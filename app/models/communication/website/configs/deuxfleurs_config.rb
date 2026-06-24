# -*- SkipSchemaAnnotations
class Communication::Website::Configs::DeuxfleursConfig < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::DeuxfleursConfig'
  end

  def git_path(website)
    "deuxfleurs.toml"
  end

  def template_static
    "admin/communication/websites/configs/deuxfleurs_config/static"
  end

end
