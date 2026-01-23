# Magic jobs for magic devs
class UnicornsJob < ApplicationJob
  queue_as :unicorns

  def perform
    Migrations::CleanAttachmentsDestroyed.migrate
  end
end