class AddTypeToCommunicationWebsitePages < ActiveRecord::Migration[7.0]
  def change
    add_column :communication_website_pages, :type, :string
  end
end
