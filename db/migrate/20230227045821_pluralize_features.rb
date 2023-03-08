class PluralizeFeatures < ActiveRecord::Migration[7.0]
  def change
    rename_column :communication_extranets, :feature_directory, :feature_contacts
    rename_column :communication_extranets, :feature_dam, :feature_assets
  end
end
