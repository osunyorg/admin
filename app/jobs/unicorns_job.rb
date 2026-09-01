# Magic jobs for magic devs
class UnicornsJob < ApplicationJob
  queue_as :unicorns

  def perform
    Migrations::BlocksWithMedias.migrate
    Migrations::BlockTitlesToFiles.migrate
    Migrations::CleanOrphanAttachments.migrate
  end
end
