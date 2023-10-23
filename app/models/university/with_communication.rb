module University::WithCommunication
  extend ActiveSupport::Concern

  included do
    has_many  :communication_extranets,
              class_name: 'Communication::Extranet',
              dependent: :destroy
    alias_method :extranets, :communication_extranets

    has_many  :communication_websites,
              class_name: 'Communication::Website',
              dependent: :destroy
    alias_method :websites, :communication_websites

    has_many  :communication_website_posts,
              class_name: 'Communication::Website::Post',
              dependent: :destroy

    has_many  :communication_blocks,
              class_name: 'Communication::Block',
              dependent: :destroy
    alias_method :blocks, :communication_blocks

    has_many  :communication_block_headings,
              class_name: 'Communication::Block::Heading',
              dependent: :destroy
    alias_method :headings, :communication_block_headings
  end
end
