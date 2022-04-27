module University::WithCommunication
  extend ActiveSupport::Concern

  included do
    has_many  :communication_extranets,
              class_name: 'Communication::Extranet',
              dependent: :destroy
    alias_attribute :extranets, :communication_extranets

    has_many  :communication_websites,
              class_name: 'Communication::Website',
              dependent: :destroy
    alias_attribute :websites, :communication_websites

    has_many  :communication_blocks,
              class_name: 'Communication::Block',
              dependent: :destroy
    alias_attribute :blocks, :communication_blocks
  end
end
