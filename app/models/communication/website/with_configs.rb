module Communication::Website::WithConfigs
  extend ActiveSupport::Concern

  included do

    def configs
      [
        config_default_content_security_policy,
        config_default_languages,
        config_default_permalinks,
        config_development_config,
        config_production_config,
        config_deuxfleurs_workflow
      ].compact
    end

    def config_default_content_security_policy
      @config_default_content_security_policy ||= Communication::Website::Configs::DefaultContentSecurityPolicy.find(id)
    end

    def config_default_languages
      @config_default_languages ||= Communication::Website::Configs::DefaultLanguages.find(id)
    end

    def config_default_permalinks
      @config_default_permalinks ||= Communication::Website::Configs::DefaultPermalinks.find(id)
    end

    def config_development_config
      @config_development_config ||= Communication::Website::Configs::DevelopmentConfig.find(id)
    end

    def config_production_config
      @config_production_config ||= Communication::Website::Configs::ProductionConfig.find(id)
    end

    def config_deuxfleurs_workflow
      return unless deuxfleurs_hosting
      @config_deuxfleurs_workflow ||= Communication::Website::Configs::DeuxfleursWorkflow.find(id)
    end

  end
end
