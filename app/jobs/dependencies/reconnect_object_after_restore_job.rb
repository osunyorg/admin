class Dependencies::ReconnectObjectAfterRestoreJob < ApplicationJob
  queue_as :elephants

  def perform(object)
    object.references.compact.each &:touch
  end
end
