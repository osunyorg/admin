class Dependencies::CleanObjectAfterDestroyJob < ApplicationJob
  queue_as :cats

  def perform(object)
    object.touch_references
    object.websites.each &:clean
  end
end
