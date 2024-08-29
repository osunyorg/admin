class RenameCommunicationWebsiteLocalizationAbout < ActiveRecord::Migration[7.1]
  def change
    # We moved the migration date to make sure this one is up before creating localizations tables.
    # To prevent this to get executed twice, we check the column existence first.
    return if connection.column_exists?(:communication_website_localizations, :about_id)
    
    rename_column :communication_website_localizations, :communication_website_id, :about_id
  end
end
