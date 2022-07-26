class AddFullWidthToCommunicationWebsitePage < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_pages, :full_width, :boolean, default: false
  end
end
