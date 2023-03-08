class AddFeaturesToCommunicationExtranets < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_extranets, :feature_alumni, :boolean, default: false
    add_column :communication_extranets, :feature_directory, :boolean, default: false
    add_column :communication_extranets, :feature_dam, :boolean, default: false
    add_column :communication_extranets, :feature_posts, :boolean, default: false
    add_column :communication_extranets, :feature_jobs, :boolean, default: false
  end
end
