class AddDescriptionShortToPage < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_pages, :description_short, :text
  end
end
