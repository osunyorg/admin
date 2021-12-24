class AddPathToCommunicationWebsiteCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_categories, :path, :string
  end
end
