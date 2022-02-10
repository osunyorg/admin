class AddDescriptionAndRemoveTitleFromHome < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_homes, :description, :text
    remove_column :communication_website_homes, :title
  end
end
