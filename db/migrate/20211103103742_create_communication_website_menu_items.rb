class CreateCommunicationWebsiteMenuItems < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_menu_items, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.references :website, null: false, foreign_key: { to_table: :communication_websites }, type: :uuid
      t.references :menu, null: false, foreign_key: { to_table: :communication_website_menus }, type: :uuid
      t.string :title
      t.integer :position
      t.integer :kind, default: 0
      t.references :parent, foreign_key: { to_table: :communication_website_menu_items }, type: :uuid
      t.references :about, polymorphic: true, type: :uuid

      t.timestamps
    end
  end
end
