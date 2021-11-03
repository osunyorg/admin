class AddUrlToCommunicationWebsiteMenuItems < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_menu_items, :url, :text
  end
end
