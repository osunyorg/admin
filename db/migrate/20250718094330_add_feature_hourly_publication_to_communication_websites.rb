class AddFeatureHourlyPublicationToCommunicationWebsites < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_websites, :feature_hourly_publication, :boolean, default: false
  end
end
