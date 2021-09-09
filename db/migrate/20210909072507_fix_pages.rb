class FixPages < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_pages, :published, :boolean, default: false
    remove_column :communication_website_pages, :published_at
  end
end
