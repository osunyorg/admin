class Communication::Website::DeleteObsoleteConnectionsJob < Communication::Website::BaseJob
  queue_as :mice

  def execute
    website.delete_obsolete_connections
  end
end