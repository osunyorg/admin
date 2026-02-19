class AddHtmlClassToCommunicationWebsiteMenuItem < ActiveRecord::Migration[8.1]
  def change
    add_column :communication_website_menu_items, :html_class, :string
  end
end
