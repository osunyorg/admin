class Communication::Website::Configs::RobotsTxt < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::RobotsTxt'
  end

  def git_path(website)
    "static/robots.txt"
  end

  def template_static
    "admin/communication/websites/configs/robots_txt/static"
  end

end
