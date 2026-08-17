# Magic jobs for magic devs
class UnicornsJob < ApplicationJob
  queue_as :unicorns

  def perform
    Migrations::DenormalizeFileExtensions.migrate
    Migrations::DenormalizeFileContexts.migrate
    Migrations::DenormalizeMediaExtensions.migrate
    Migrations::DenormalizeMediaContexts.migrate
  end
end
