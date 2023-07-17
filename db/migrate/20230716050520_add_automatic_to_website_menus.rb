class AddAutomaticToWebsiteMenus < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_website_menus, :automatic, :boolean, default: true

    Communication::Website::Menu.find_each do |menu|
      menu.update_column :automatic, false if menu.items.any?
    end
  end
end
