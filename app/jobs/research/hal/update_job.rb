class Research::Hal::UpdateJob < ApplicationJob
  queue_as :elephant

  def perform
    Research::Hal.update_from_api!
  end
end
