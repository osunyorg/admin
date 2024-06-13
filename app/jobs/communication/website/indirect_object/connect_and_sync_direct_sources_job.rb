# Ce n'est pas un Job qui hérite de Communication::Website::BaseJob, 
# il n'y a pas de besoin de lock ni de lien avec un site en particulier.
class Communication::Website::IndirectObject::ConnectAndSyncDirectSourcesJob < ApplicationJob
  queue_as :mice

  def perform(indirect_object)
    indirect_object.connect_and_sync_direct_sources_safely
  end
end