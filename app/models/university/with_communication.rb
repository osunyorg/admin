module University::WithCommunication
  extend ActiveSupport::Concern

  included do
    has_many :communication_websites, class_name: 'Communication::Website', dependent: :destroy
  end
end
