class AddTitleToWebsiteHome < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_homes, :title, :string, default: 'Home'
  end
end
