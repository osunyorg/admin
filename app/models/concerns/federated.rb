# frozen_string_literal: true
module Federated
  extend ActiveSupport::Concern

  included do
    has_many  :content_federations,
              class_name: "Communication::Website::ContentFederation",
              dependent: :destroy,
              as: :about
    
    has_many  :destination_websites,
              through: :content_federations    
  end
end