class AddBlankToCommunicationWebsiteMenuItems < ActiveRecord::Migration[7.2]
  def change
    add_column :communication_website_menu_items, :should_open_new_tab, :boolean, default: false
  end
end