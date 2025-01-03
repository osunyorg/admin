module University::WithCommunication
  extend ActiveSupport::Concern

  included do
    has_many  :communication_blocks,
              class_name: 'Communication::Block',
              dependent: :destroy
    alias_method :blocks, :communication_blocks

    has_many  :communication_extranets,
              class_name: 'Communication::Extranet',
              dependent: :destroy
    alias_method :extranets, :communication_extranets

    has_many  :communication_medias,
              class_name: 'Communication::Media',
              dependent: :destroy
    alias_method :medias, :communication_medias

    has_many  :communication_websites,
              class_name: 'Communication::Website',
              dependent: :destroy
    alias_method :websites, :communication_websites

    has_many  :communication_website_posts,
              class_name: 'Communication::Website::Post',
              dependent: :destroy

    has_many  :communication_website_events,
              class_name: 'Communication::Website::Agenda::Event',
              dependent: :destroy

    has_many  :communication_website_projects,
              class_name: 'Communication::Website::Portfolio::Project',
              dependent: :destroy
  end
end
