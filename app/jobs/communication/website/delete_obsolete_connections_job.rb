class Communication::Website::DeleteObsoleteConnectionsJob < Communication::Website::BaseJob
  queue_as :cats

  def execute
    website.delete_obsolete_connections_safely
  end
end