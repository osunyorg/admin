class AddInfosToCommunicationWebsiteCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_categories, :slug, :string
    add_reference :communication_website_categories, :parent, foreign_key: { to_table: :communication_website_categories }, type: :uuid

  end
end
