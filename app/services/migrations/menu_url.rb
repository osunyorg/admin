class Migrations::MenuUrl
  def self.migrate
    Communication::Website::Menu::Item.find_each do |item|
      next unless item.kind_url?
      puts item.url
      should_open_new_tab = item.url.start_with?('http')
      puts should_open_new_tab
      item.update_column :should_open_new_tab, should_open_new_tab
    end
  end
end