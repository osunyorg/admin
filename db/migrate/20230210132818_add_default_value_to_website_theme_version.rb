class AddDefaultValueToWebsiteThemeVersion < ActiveRecord::Migration[7.0]
  def change
    change_column_default :communication_websites, :theme_version, 'NA'
    Communication::Website.where(theme_version: nil).update_all(theme_version: 'NA')
  end
end
