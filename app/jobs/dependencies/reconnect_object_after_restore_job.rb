class Dependencies::ReconnectObjectAfterRestoreJob < ApplicationJob
  queue_as :elephants

  def perform(object)
    object.touch
    object.references.compact.each &:touch
  end
end
