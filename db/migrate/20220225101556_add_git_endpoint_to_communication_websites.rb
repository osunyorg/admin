class AddGitEndpointToCommunicationWebsites < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_websites, :git_endpoint, :string
  end
end
