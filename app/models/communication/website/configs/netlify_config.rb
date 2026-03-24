# -*- SkipSchemaAnnotations
class Communication::Website::Configs::NetlifyConfig < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::NetlifyConfig'
  end

  def git_path(website)
    "netlify.toml"
  end

  def template_static
    "admin/communication/websites/configs/netlify_config/static"
  end

end
