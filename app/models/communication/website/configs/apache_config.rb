# -*- SkipSchemaAnnotations
class Communication::Website::Configs::ApacheConfig < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::ApacheConfig'
  end

  def git_path(website)
    "static/.htaccess"
  end

  def template_static
    "admin/communication/websites/configs/apache_config/static"
  end

end
