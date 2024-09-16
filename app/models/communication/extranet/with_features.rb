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
  end

  def has_feature?(identifier)
    public_send "feature_#{identifier}"
  end
end
