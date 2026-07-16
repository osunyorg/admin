class Migrations::HandleLegacyFilesBlocksJob < ApplicationJob
  queue_as :unicorns

  def perform
    Migrations::HandleLegacyFilesBlocks.migrate
  end
end
