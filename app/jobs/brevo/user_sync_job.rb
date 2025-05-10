class Brevo::UserSyncJob < ApplicationJob
  def perform(user)
    Brevo::ContactService.sync(user)
  end
end