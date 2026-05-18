# -*- SkipSchemaAnnotations
class Communication::Website::Configs::NginxConfig < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::NginxConfig'
  end

  def can_have_git_file?
    false
  end

  def template_static
    "admin/communication/websites/configs/nginx_config/static"
  end

end
