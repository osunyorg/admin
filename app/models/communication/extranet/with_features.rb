module Communication::Extranet::WithFeatures
  extend ActiveSupport::Concern

  included do
    FEATURES = [
      :alumni,
      :contacts,
      :posts,
      :files,
      :jobs,
    ]
  end

  def feature?(identifier)
    public_send "feature_#{identifier}"
  end
end