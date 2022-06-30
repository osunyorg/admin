class AddStyleToWebsite < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_websites, :style, :text
    add_column :communication_websites, :style_updated_at, :date
  end
end
