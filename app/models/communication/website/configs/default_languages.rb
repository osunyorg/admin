class Communication::Website::Configs::DefaultLanguages < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::DefaultLanguages'
  end

  def git_path(website)
    "config/_default/languages.yaml"
  end

  def template_static
    "admin/communication/websites/configs/default_languages/static"
  end

end
