class MigrateCommunicationWebsiteMenuItemsAbout < ActiveRecord::Migration[7.1]
  def up
    Communication::Website::Menu::Item.where.not(kind: [:blank, :url]).find_each do |menu_item|
      about = menu_item.about
      next if about.nil?
      puts "Migration menu item #{menu_item.id}"
      # Kind like paper can't respond to original_id
      about_id = about.try(:original_id) || about.id
      menu_item.update_column :about_id, about_id
    end
  end

  def down
  end
end
