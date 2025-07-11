class AddFeatureAlertsToCommunicationWebsites < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_websites, :feature_alerts, :boolean, default: false
  end
end
