class RenameCommunicationWebsiteLocalizationAbout < ActiveRecord::Migration[7.1]
  def change
    rename_column :communication_website_localizations, :communication_website_id, :about_id
  end
end
