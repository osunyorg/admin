class AddBlankToCommunicationWebsiteMenuItems < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_menu_items, :blank, :boolean, default: false
  end
end
