class Dependencies::CleanObjectAfterDestroyJob < ApplicationJob
  queue_as :cats

  def perform(object)
    object.references.compact.each &:touch
    object.websites.each &:clean_safely
  end
end
