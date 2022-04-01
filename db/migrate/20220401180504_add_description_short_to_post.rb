class AddDescriptionShortToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_posts, :description_short, :text
  end
end
