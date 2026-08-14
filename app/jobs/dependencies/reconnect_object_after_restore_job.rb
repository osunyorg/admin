class Dependencies::ReconnectObjectAfterRestoreJob < ApplicationJob
  queue_as :elephants

  def perform(object)
    object.touch
    object.references.to_a.flatten.compact.each &:touch
  end
end
