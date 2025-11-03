class Dependencies::ReconnectObjectAfterRestoreJob < ApplicationJob
  queue_as :elephant

  def perform(object)
    # TODO paranoia: à écrire
  end
end
