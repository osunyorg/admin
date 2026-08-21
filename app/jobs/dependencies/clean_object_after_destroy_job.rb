class Dependencies::CleanObjectAfterDestroyJob < ApplicationJob
  queue_as :cats

  def perform(object)
    object.references.to_a.flatten.compact.each &:touch
    object.websites.each &:clean
  end
end
