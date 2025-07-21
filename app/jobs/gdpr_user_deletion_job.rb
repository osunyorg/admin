class GdprUserDeletionJob < ApplicationJob
  queue_as :default

  def perform
    service = Gdpr::UserDeletionService.new
    service.handle_users
  end

end