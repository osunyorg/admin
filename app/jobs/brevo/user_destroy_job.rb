class Brevo::UserDestroyJob < ApplicationJob
  def perform(contact_id)
    Brevo::ContactService.destroy(contact_id)
  end
end