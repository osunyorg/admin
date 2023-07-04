class AddStatusToCommunicationWebsites < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_websites, :deployment_status_badge, :text
  end
end
