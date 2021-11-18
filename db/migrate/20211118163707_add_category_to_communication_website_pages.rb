class AddCategoryToCommunicationWebsitePages < ActiveRecord::Migration[6.1]
  def change
    add_reference :communication_website_pages, :category, foreign_key: { to_table: :communication_website_categories }, type: :uuid
  end
end
