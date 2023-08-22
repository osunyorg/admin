class AddAutoupdateThemeToCommunicationWebsites < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_websites, :autoupdate_theme, :boolean, default: true
  end
end
