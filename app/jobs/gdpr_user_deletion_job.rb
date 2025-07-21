class GdprUserDeletionJob < ApplicationJob
  queue_as :default

  def perform
    service = Gdpr::UserDeletionService.new
    service.handle_users
    puts "[GDPR]: #{service.users_to_alert.count} alerted users & #{service.users_to_delete.count} deleted users."
  end

end