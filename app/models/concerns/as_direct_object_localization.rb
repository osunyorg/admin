module AsDirectObjectLocalization
  extend ActiveSupport::Concern

  included do
    before_validation :set_communication_website_id, on: :create
  end

  def federated_in?(website)
    about.respond_to?(:federated_in?) && about.federated_in?(website)
  end

  protected

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end
end