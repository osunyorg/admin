module Communication::Extranet::WithFeatures
  extend ActiveSupport::Concern

  included do
    FEATURES = [
      :alumni,
      :contacts,
      :posts,
      :assets,
      :jobs,
    ]
  end

  def feature?(identifier)
    send "feature_#{identifier}"
  end
end