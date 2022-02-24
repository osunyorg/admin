module Communication::Website::WithConfigs
  extend ActiveSupport::Concern

  included do

    def config_permalinks
      @config_permalinks ||= Communication::Website::Configs::Permalinks.find(id)
    end

    def config_base_url
      @config_base_url ||= Communication::Website::Configs::BaseUrl.find(id)
    end

  end
end
