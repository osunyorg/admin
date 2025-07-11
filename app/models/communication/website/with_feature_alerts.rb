module Communication::Website::WithFeatureAlerts
  extend ActiveSupport::Concern

  included do
    has_many    :alerts,
                class_name: "Communication::Website::Alert",
                foreign_key: :communication_website_id,
                dependent: :destroy

    scope :with_feature_alerts, -> { where(feature_alerts: true) }
  end

  def feature_alerts_dependencies
    alerts
  end
end
