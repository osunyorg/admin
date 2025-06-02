# frozen_string_literal: true
module Communication::Website::WithFederations
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :source_websites,
                            join_table: :communication_website_federations,
                            foreign_key: :destination_website_id,
                            association_foreign_key: :source_website_id,
                            class_name: 'Communication::Website'
    has_and_belongs_to_many :destination_websites,
                            join_table: :communication_website_federations,
                            foreign_key: :source_website_id,
                            association_foreign_key: :destination_website_id,
                            class_name: 'Communication::Website'

    has_many  :content_federations_as_destination,
              class_name: "Communication::Website::ContentFederation",
              dependent: :destroy,
              foreign_key: :destination_website_id
    
    has_many  :federated_communication_website_agenda_events,
              through: :content_federations_as_destination,
              source: :about,
              source_type: "Communication::Website::Agenda::Event"
  end
end