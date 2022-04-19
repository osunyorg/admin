class AddBodyclassToCommunicationWebsitePage < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_pages, :bodyclass, :string
  end
end
