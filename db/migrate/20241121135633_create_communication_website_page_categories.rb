class CreateCommunicationWebsitePageCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :communication_website_page_categories, id: :uuid do |t|
      t.boolean :is_taxonomy, default: false
      t.integer :position

      t.references :communication_website, null: false, foreign_key: { to_table: :communication_websites }, type: :uuid, index: { name: 'idx_communication_website_page_cats_on_website_id' }
      t.references :parent, foreign_key: {to_table: :communication_website_page_categories}, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
