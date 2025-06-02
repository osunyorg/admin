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
    alias     :federated_websites :destination_websites
  end

  def federated?
    content_federations.any?
  end

  # --www-communication-democratie-fr
  def suffix_in(destination_website)
    is_federated_in?(destination_website) ? "--#{website.domain_slug}"
                                          : ''
  end

  def is_direct_in?(website)
    communication_website_id == website.id
  end

  def is_federated_in?(website)
    website.in?(destination_websites)
  end

  def is_allowed_in?(website)
    is_direct_in?(website) || is_federated_in?(website)
  end
end