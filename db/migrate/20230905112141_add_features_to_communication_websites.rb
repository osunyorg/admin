class AddFeaturesToCommunicationWebsites < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_websites, :feature_posts, :boolean, default: true
    add_column :communication_websites, :feature_agenda, :boolean, default: false
  end
end
