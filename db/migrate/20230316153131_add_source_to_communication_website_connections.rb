class AddSourceToCommunicationWebsiteConnections < ActiveRecord::Migration[7.0]
  def change
    add_reference :communication_website_connections, :source, polymorphic: true, type: :uuid
  end
end
