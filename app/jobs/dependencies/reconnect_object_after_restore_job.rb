class Dependencies::ReconnectObjectAfterRestoreJob < ApplicationJob
  queue_as :elephants

  def perform(object)
    object.touch
    object.references.flatten.compact.each &:touch
  end
end
