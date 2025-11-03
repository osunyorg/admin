class Dependencies::CleanObjectAfterDestroyJob < ApplicationJob
  queue_as :elephant

  def perform(object)
    object.references.compact.each &:touch
    object.websites.each &:clean_safely
  end
end
