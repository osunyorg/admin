# Magic jobs for magic devs
class UnicornsJob < ApplicationJob
  queue_as :unicorns

  def perform
    Migrations::OrganizationsBlocksLogosToMedias.migrate
  end
end
