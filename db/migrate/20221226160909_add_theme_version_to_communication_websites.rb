class AddThemeVersionToCommunicationWebsites < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_websites, :theme_version, :string
  end
end
