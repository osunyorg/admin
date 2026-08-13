class Dependencies::ReconnectObjectAfterRestoreJob < ApplicationJob
  queue_as :elephants

  def perform(object)
    object.touch
    object.touch_references
  end
end
