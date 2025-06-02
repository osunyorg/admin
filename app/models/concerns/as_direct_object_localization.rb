module AsDirectObjectLocalization
  extend ActiveSupport::Concern

  included do
    before_validation :set_communication_website_id, on: :create

    delegate :is_federated_in?, to: :about
  end

  protected

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end
end