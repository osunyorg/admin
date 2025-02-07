module Communication::Extranet::WithFeatures
  extend ActiveSupport::Concern

  included do
    FEATURES = [
      :posts,
      :contacts,
      :documents,
      :alumni,
      :jobs,
    ]

  validate :feature_alumni_is_available

  end

  def has_feature?(identifier)
    public_send "feature_#{identifier}"
  end

  private

  def feature_alumni_is_available
    errors.add(:feature_alumni, :unavailable) if feature_alumni? && !about.respond_to?(:cohorts)
  end
end
