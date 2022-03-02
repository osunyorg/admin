module University::WithCommunication
  extend ActiveSupport::Concern

  included do
    has_many :communication_extranets, class_name: 'Communication::Extranet', dependent: :destroy
    has_many :communication_websites, class_name: 'Communication::Website', dependent: :destroy
    has_many :communication_blocks, class_name: 'Communication::Block', dependent: :destroy
  end
end
