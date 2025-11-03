class Dependencies::ReconnectObjectAfterRestoreJob < ApplicationJob
  queue_as :elephant

  def perform(object)
    object.references.compact.each &:touch
  end
end
