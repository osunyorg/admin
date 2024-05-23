class Communication::Website::DeleteObsoleteConnectionsJob < Communication::Website::BaseJob
  queue_as :low_priority

  def execute
    website.delete_obsolete_connections
  end
end