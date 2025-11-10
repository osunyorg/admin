class AddDeletedAtToCommunicationAlerts < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_website_alerts, :deleted_at, :datetime
    add_column :communication_website_alert_localizations, :deleted_at, :datetime
  end
end
