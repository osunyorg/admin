# Magic jobs for magic devs
class UnicornsJob < ApplicationJob
  queue_as :unicorns

  def perform
    Migrations::DenormalizeWebsitesInFileContexts.migrate
    Migrations::DenormalizeFileExtensions.migrate
    Migrations::DenormalizeMediaExtensions.migrate
  end
end
