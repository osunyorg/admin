class Migrations::L10n::Communication::Website::Menu < Migrations::L10n::Base
  def self.execute
    Communication::Website::Menu::Item.where.not(kind: [:blank, :url]).find_each do |menu_item|
      about = menu_item.about
      next if about.nil?
      puts "Migration menu item #{menu_item.id}"
      # Kind like paper can't respond to original_id
      about_id = about.try(:original_id) || about.id
      menu_item.update_column :about_id, about_id
    end
  end
end