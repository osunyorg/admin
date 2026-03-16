module Communication::Website::WithConfigs
  extend ActiveSupport::Concern

  included do
    def self.config_files
      [
        :apache_config,
        :default_content_security_policy,
        :default_languages,
        :deuxfleurs_config,
        :deuxfleurs_workflow,
        :development_config,
        :netlify_config,
        :nginx_config,
        :production_config,
        :robots_txt
      ]
    end
  end

  def configs
    [
      config_apache_config,
      config_default_content_security_policy,
      config_default_languages,
      config_development_config,
      config_production_config,
      config_deuxfleurs_workflow,
      config_deuxfleurs_config,
      config_netlify_config,
      config_nginx_config,
      config_robots_txt,
    ].compact
  end

  def config_apache_config
    return unless hosted_with_apache?
    @config_apache_config ||= Communication::Website::Configs::ApacheConfig.find(id)
  end

  def config_default_content_security_policy
    @config_default_content_security_policy ||= Communication::Website::Configs::DefaultContentSecurityPolicy.find(id)
  end

  def config_default_languages
    @config_default_languages ||= Communication::Website::Configs::DefaultLanguages.find(id)
  end

  def config_development_config
    @config_development_config ||= Communication::Website::Configs::DevelopmentConfig.find(id)
  end

  def config_production_config
    @config_production_config ||= Communication::Website::Configs::ProductionConfig.find(id)
  end

  def config_deuxfleurs_workflow
    return unless hosted_with_deuxfleurs?
    @config_deuxfleurs_workflow ||= Communication::Website::Configs::DeuxfleursWorkflow.find(id)
  end

  def config_deuxfleurs_config
    return unless hosted_with_deuxfleurs?
    @config_deuxfleurs_config ||= Communication::Website::Configs::DeuxfleursConfig.find(id)
  end

  def config_netlify_config
    return unless hosted_with_netlify?
    @config_netlify_config ||= Communication::Website::Configs::NetlifyConfig.find(id)
  end

  def config_nginx_config
    return unless hosted_with_nginx?
    @config_nginx_config ||= Communication::Website::Configs::NginxConfig.find(id)
  end

  def config_robots_txt
    @config_robots_txt ||= Communication::Website::Configs::RobotsTxt.find(id)
  end
end
