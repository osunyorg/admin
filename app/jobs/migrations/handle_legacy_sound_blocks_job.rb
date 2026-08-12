class Migrations::HandleLegacySoundBlocksJob < ApplicationJob
  queue_as :unicorns

  def perform
    Migrations::HandleLegacySoundBlocks.migrate
  end
end
