module University::WithIdentifier
  extend ActiveSupport::Concern

  included do
    # TODO restrict to lower case, numbers, -, _
    validates :identifier, presence: true, uniqueness: true

    def self.with_host(host)
      find_by(identifier: extract_identifier_from(host))
    end

    private

    # University direct urls (not through website)
    # Production  osuny.osuny.org   -> osuny
    # Staging     osuny.osuny.dev   -> osuny
    # Dev         osuny.osuny       -> osuny
    def self.extract_identifier_from(host)
      host.remove(production_domain)
          .remove(staging_domain)
          .remove(dev_domain)
    end

    def self.production_domain
      ENV['OSUNY_PRODUCTION'] || '.osuny.org'
    end

    def self.staging_domain
      ENV['OSUNY_STAGING'] || '.osuny.dev'
    end

    def self.dev_domain
      ENV['OSUNY_DEV'] || '.osuny'
    end
  end

  def domain_url
    case Rails.env
    when 'development'
      "http://#{identifier}#{University.dev_domain}:3000"
    when 'staging'
      "https://#{identifier}#{University.staging_domain}"
    when 'production'
      "https://#{identifier}#{University.production_domain}"
    end
  end
end
