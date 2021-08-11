module University::WithIdentifier
  extend ActiveSupport::Concern

  included do
    # TODO restrict to lower case, numbers, -, _
    validates :identifier, presence: true, uniqueness: true
  end

  class_methods do
    def with_host(host)
      find_by(identifier: extract_identifier_from(host)) || first
    end

    private

    # University direct urls (not through website)
    # Production  osuny.osuny.org   -> osuny
    # Staging     osuny.osuny.dev   -> osuny
    # Dev         osuny.osuny       -> osuny
    def extract_identifier_from(host)
      host.remove('.osuny.org')
          .remove('.osuny.dev')
          .remove('.osuny')
    end
  end

  def domain_url
    case Rails.env
    when 'development'
      "http://#{identifier}.osuny:3000"
    when 'staging'
      "https://#{identifier}.osuny.dev"
    when 'production'
      "https://#{identifier}.osuny.org"
    end
  end
end
