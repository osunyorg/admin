class AddFeatureJobboardToWebsites < ActiveRecord::Migration[8.0]
  def change
    add_column :communication_websites, :feature_jobboard, :boolean, default: false
  end
end
