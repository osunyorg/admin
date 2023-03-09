module Communication::Extranet::WithFeatures
  extend ActiveSupport::Concern

  included do
    FEATURES = [
      :alumni,
      :contacts,
      :posts,
      :library,
      :jobs,
    ]
  end

  def has_feature?(identifier)
    public_send "feature_#{identifier}"
  end
end
