class AddPublishedToExtranetLocalizations < ActiveRecord::Migration[7.1]
  def up
    add_column :communication_extranet_localizations, :published, :boolean, default: false
    add_column :communication_extranet_localizations, :published_at, :datetime
    Communication::Extranet::Localization.reset_column_information
    Communication::Extranet::Localization.update_all("published = true, published_at = created_at")
  end
  def down
    remove_column :communication_extranet_localizations, :published, :boolean, default: false
    remove_column :communication_extranet_localizations, :published_at, :datetime
  end
end
