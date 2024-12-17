class Migrations::MenuUrl
  def self.migrate
    Communication::Website::Menu::Item.find_each do |item|
      next unless item.kind_url?
      puts item.url
      blank = item.url.start_with?('https://')
      puts blank
      item.update_column :blank, blank
    end
  end
end