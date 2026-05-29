class AddUniqueIndexToCommunicationWebsitePagesType < ActiveRecord::Migration[8.1]
  def change
    add_index :communication_website_pages, [:communication_website_id, :type], unique: true, where: "(type IS NOT NULL)"
  end
end
