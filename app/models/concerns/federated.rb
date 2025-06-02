# frozen_string_literal: true
module Federated
  extend ActiveSupport::Concern

  included do
    has_many  :content_federations,
              class_name: "Communication::Website::ContentFederation",
              dependent: :destroy,
              as: :about
    
    has_many  :destination_websites,
              through: :content_federations,
              dependent: :destroy
    alias     :federated_websites :destination_websites
  end

  def federated?
    content_federations.any?
  end

  # --www-communication-democratie-fr
  def suffix_in(destination_website)
    federated_in?(destination_website) ? "--#{website.domain_slug}"
                                          : ''
  end

  def direct_in?(website)
    communication_website_id == website.id
  end

  def federated_in?(website)
    website.in?(destination_websites)
  end

  def allowed_in?(website)
    direct_in?(website) || federated_in?(website)
  end

end