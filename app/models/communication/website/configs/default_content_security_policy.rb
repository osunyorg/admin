class Communication::Website::Configs::DefaultContentSecurityPolicy < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::DefaultContentSecurityPolicy'
  end

  def git_path(website)
    "data/content_security_policy.yaml"
  end

  def template_static
    "admin/communication/websites/configs/default_content_security_policy/static"
  end

end
