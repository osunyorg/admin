class Dependencies::CleanObjectAfterDestroyJob < ApplicationJob
  queue_as :cats

  def perform(object)
    object.references.flatten.compact.each &:touch
    object.websites.each &:clean
  end
end
