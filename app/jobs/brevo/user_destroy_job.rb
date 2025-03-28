class Brevo::UserDestroyJob < ApplicationJob
  def perform(contact_id, university_id)
    Brevo::ContactService.destroy(contact_id, university_id)
  end
end