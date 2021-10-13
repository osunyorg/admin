module University::WithIdentifier
  extend ActiveSupport::Concern

  included do
    # TODO restrict to lower case, numbers, -, _
    validates :identifier, presence: true, uniqueness: true

    def host
      @host ||= [identifier, self.class.send("#{ENV['APPLICATION_ENV']}_domain")].join
    end

    def url
      @url ||= Rails.env.development? ? "http://#{host}:3000" : "https://#{host}"
    end

    def self.with_host(host)
      find_by!(identifier: extract_identifier_from(host))
    end

    private

    # University direct urls (not through website)
    # Production  osuny.osuny.org   -> osuny
    # Staging     osuny.osuny.dev   -> osuny
    # Dev         osuny.osuny       -> osuny
    def self.extract_identifier_from(host)
      host.remove self.send("#{ENV['APPLICATION_ENV']}_domain")
    end

    def self.production_domain
      ENV['OSUNY_PRODUCTION'] || '.osuny.org'
    end

    def self.staging_domain
      ENV['OSUNY_STAGING'] || '.osuny.dev'
    end

    def self.development_domain
      ENV['OSUNY_DEV'] || '.osuny'
    end
  end
end
