class Research::Hal::UpdateJob < ApplicationJob
  queue_as :low_priority

  def perform
    Research::Hal.update_from_api!
  end
end
